//
//  HabitsListView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 13.06.2022.
//

import SwiftUI

struct HabitsListView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.startDate, ascending: false)], predicate: nil, animation: .easeInOut) var habits: FetchedResults<Habit>
    
    @StateObject var habitModel: HabitViewModel = .init()
    @StateObject var habitsListViewModel = HabitsListViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundColorContent.ignoresSafeArea()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10){
                        
                    }
                }
                ScrollView(habits.isEmpty ? .init(): .vertical, showsIndicators: false){
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10){
                            
                            ForEach(habitModel.currentWeek,id: \.self){day in
                                
                                VStack(spacing: 10){
                                    
                                    Text(habitModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color("Card-5"))
                                    
                                    Text(habitModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 17,weight: .bold))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(habitModel.isToday(date: day) ? 1 : 0)
                                }
                                
                                .foregroundStyle(habitModel.isToday(date: day) ? Color("Card-1") : .white)
                                .foregroundColor(habitModel.isToday(date: day) ? .white : .black)
                                
                                .frame(width: 45, height: 90)
                                .background(
                                    
                                    ZStack{
                                        if habitModel.isToday(date: day){
                                            Capsule()
                                                .fill(Color("Card-4"))
                                            
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        habitModel.currentDay = day
                                        let weekDay = habitModel.extractDate(date: day, format: "EEEE")
                                        habitsListViewModel.getHabitsListByWeekDay(weekday: weekDay)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 15){
                        
                        VStack(spacing: 15){
                            if !habitsListViewModel.habitsFilterByDay.isEmpty {
                                ForEach(habitsListViewModel.habitsFilterByDay){ habit in
                                    NavigationLink{
                                        CheckHabitView(oneHabit: habit)
                                    } label: {
                                        ShortHabit(habit: habit)
                                    }
                                }
                            } else {
                                Text("Not set")
                            }
                        }
                        .padding()
                    }
                }
                
            }.navigationBarHidden(true)
        }
        .environmentObject(habitModel)
    }
    @ViewBuilder
    func ShortHabit(habit: Habit)->some View{
        HStack(spacing: 12){
            let letter = habit.title?.first
            Text(String(letter ?? "T"))
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background{
                    Circle()
                        .fill(Color(habit.habitColor ?? "Card-1" ))
                }
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            
            VStack(spacing: 5){
                Text(habit.title ?? "")
                    .font(.system(size: 15, weight: .black))
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                Text(habit.habitDescription ?? "")
                    .font(.system(size: 15, weight: .black))
                    .lineLimit(1)
                    .foregroundColor(Color(habit.habitColor ?? "Card-1"))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,alignment: .leading)
            }
            VStack(alignment: .trailing, spacing: 7) {
                
                let dateTextFormatStart = habit.startDate?.formatted(date: .long, time: .omitted)
                Text(dateTextFormatStart ?? "Not set")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
                .opacity(0.6)
        }
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
}

struct HabitsListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsListView()
    }
}
