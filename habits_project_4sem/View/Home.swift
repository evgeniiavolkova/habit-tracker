//
//  Home.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 02.06.2022.
//

import SwiftUI

struct Home: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.startDate, ascending: false)], predicate: nil, animation: .easeInOut) var habits: FetchedResults<Habit>
    @StateObject var habitModel: HabitViewModel = .init()
    @StateObject var locationManager: LocationManager = .init()
    
    var body: some View {
        ZStack{
            backgroundColorContent.ignoresSafeArea()
            VStack(spacing: 0){
                
                Text("Today")
                    .font(.system(size: 17, weight: .heavy))
                    .frame(maxWidth:.infinity)
                    .overlay(alignment: .trailing){
                        // add new habit
                        Button{
                            habitModel.addNewhabit.toggle()
                        }label:{
                            Image(systemName: "gearshape")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.bottom,10)
                Text( (Formatter.init().formatter.string(from: Date() )) )
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(Color(#colorLiteral(red: 0.3, green: 0.13, blue: 0.7, alpha: 1)))
                    .tracking(-0.41)
                    .padding(.bottom, 10)
                
                ScrollView(habits.isEmpty ? .init(): .vertical, showsIndicators: false){
                    VStack(spacing: 15){
                        
                        ForEach(habits){ habit in
                            HabitCardView(habit: habit)
                        }
                        
                        Button{
                            habitModel.addNewhabit.toggle()
                            
                        } label :{
                            Label{
                                Text("New habit")
                            } icon: {
                                Image(systemName: "plus.circle")
                            }
                            .font(.callout.bold())
                            .foregroundColor(.white)
                        }
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .padding(.vertical)
                    .sheet(isPresented: $habitModel.addNewhabit){
                        habitModel.resetData()
                    } content: {
                        AddNewHabit()
                            .environmentObject(habitModel)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
        .environmentObject(locationManager)
    }
    
    
    var backgroundColorContent : some View{
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.6666666865348816, green: 0.3921568691730499, blue: 0.7960784435272217, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0.9058823585510254, green: 0.5529412031173706, blue: 0.7450980544090271, alpha: 1)), location: 0.270621120929718),
                .init(color: Color(#colorLiteral(red: 0.8705882430076599, green: 0.5796313881874084, blue: 0.5529412031173706, alpha: 1)), location: 0.5689336657524109),
                .init(color: Color(#colorLiteral(red: 0.9764705896377563, green: 0.8666666746139526, blue: 0.729411780834198, alpha: 1)), location: 0.8371358513832092)]),
            startPoint: UnitPoint(x: 1.1102230246251565e-16, y: 8.326672684688674e-17),
            endPoint: UnitPoint(x: 1.1119402583942715, y: 1.3807229378987198))
    }
    
    // One row view
    @ViewBuilder
    func HabitCardView(habit: Habit)->some View{
        VStack(spacing: 6){
            ZStack{
            }
            HStack(spacing: 10){
                let letter = habit.title?.first
                Text(String(letter ?? "T"))
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background{
                        Circle()
                            .fill(Color(habitModel.habitColor == "Card-5" ? .black : .white))
                    }
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                Text(habit.title ?? "")
                    .font(.system(size: 15, weight: .black))
                    .lineLimit(1)
                    .foregroundColor(Color(habitModel.habitColor == "Card-5" ? .black : .white))
                
                Text(habit.habitDescription ??  "")
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(Color(habitModel.habitColor == "Card-5" ? .black : .white))
                Spacer()
                
                let count = (habit.weekDays?.count ?? 0)
                Text (count == 7 ? "Everyday" : "\(count) times a week")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            
            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
            let symbols = calendar.weekdaySymbols
            let startdate = currentWeek?.start ?? Date()
            let activeWeekDays = habit.weekDays ?? []
            let activePlot = symbols.indices.compactMap{ index -> (String, Date) in
                let currentdate = calendar.date(byAdding: .day, value: index, to: startdate)
                return (symbols[index], currentdate!)
            }
            
            HStack(spacing: 0){
                ForEach(activePlot.indices, id: \.self){index in
                    let item = activePlot[index]
                    
                    VStack(spacing: 6){
                        Text(item.0.prefix(3))
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(Color(habit.habitColor ?? "Card-1"))
                        
                        let status = activeWeekDays.contains{ day in
                            return day == item.0
                        }
                        Text(getDate(date: item.1))
                            .font(.system(size: 15, weight: .bold))
                            .padding(8)
                            .background{
                                Circle()
                                    .fill(Color(habit.habitColor ?? "Card-1"))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 15)
        }
        .padding(.vertical)
        .padding(.horizontal, 6)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("OneRowColor")).opacity(0.5)
        }
        .onTapGesture {
            habitModel.editHabit = habit
            habitModel.restoreEditData()
            habitModel.addNewhabit.toggle()
        }
        
    }
        
    
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
