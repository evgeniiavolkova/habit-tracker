//
//  StatisticsView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 15.06.2022.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var date = Date()
    @EnvironmentObject var habit: HabitViewModel
    @State var daysBetween: Int
    @State var startDate: Date
    
    //var viewModel :StatisticsViewModel = StatisticsViewModel.init(habitId: habit.id)
    
    func getUnmet() -> Int {
        if daysBetween - habit.countDone > 0{
            return daysBetween - habit.countDone
        } else {
            return 0
        }
    }
    
    
    var body: some View {
        ZStack{
            BackgroundContent().ignoresSafeArea()
            VStack{
                
                Text("Statistic")
                    .font(.system(size: 17, weight: .heavy))
                    .frame(maxWidth:.infinity)
                    .foregroundColor(Color("Card-1"))
                DatePicker(
                        "Start Date",
                        selection: $date, in: startDate...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .frame(width: 345)
                    .background{
                        RoundedRectangle(cornerRadius: 10).fill(.white)
                    }
                    .padding(.top, 20)
                    .accentColor(Color("Card-6"))
            
                statisticsFields
                
                Spacer()
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label{
                        Text("Back")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .heavy))
                            
                    } icon: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                }.background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Card-1"))
                        .frame(width: 100, height: 50)
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
       
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var db = 0
    static var startDate = Date()
    static var previews: some View {
        StatisticsView(daysBetween: db, startDate: startDate).environmentObject(HabitViewModel())
    }
}

extension StatisticsView {
    
    private var statisticsFields: some View {
        HStack(spacing: 10){
            VStack{
                Text("Total Done")
                    .font(.system(size: 12, weight: .heavy)).foregroundColor(Color(.white))
                
                // писать количесво исполнений
                Text("\(habit.countDone)")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(Color("Card-1"))
                    .padding(.top, 1)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 80, height: 40)
                            
                    }
            }
            //.frame(maxWidth: .infinity)
            //.padding(.horizontal, 30)
            .padding(.top, 30)
            
            
            VStack{
                Text("Days from start")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .heavy)).foregroundColor(Color(.white))
                
                // писать количесво исполнений
                Text("\(daysBetween)")
                
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(Color("Card-1"))
                    .padding(.top, 1)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 80, height: 40)
                            
                    }
            }
            //.frame(alignment: .center)
            //.padding(.horizontal, 30)
            .padding(.top, 30)
            .padding()

            
            VStack{
                Text("Unmet")
                    .font(.system(size: 12, weight: .heavy)).foregroundColor(Color(.white))
                
                // писать количесво исполнений
                Text("\(getUnmet())")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(Color("Card-1"))
                    .padding(.top, 1)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 80, height: 40)
                            
                    }
            }
            //.frame(alignment: .center)
            //.padding(.horizontal, 30)
            .padding(.top, 30)
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
