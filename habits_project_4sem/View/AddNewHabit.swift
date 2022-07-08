//
//  AddNewHabit.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 03.06.2022.
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.self) var env
    @State private var placeName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                backgroundColorContent.ignoresSafeArea()
                VStack(spacing: 10){
                    
                    Text("Title")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .foregroundColor(.white)
                    
                    TextField("Title", text: $habitModel.title)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    
                    
                    Text("Habit description")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .foregroundColor(.white)
                    
                    TextField("Description", text: $habitModel.habitDescription)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    //COLOR
                    HStack(spacing: 0){
                        ForEach(1...7, id: \.self){index in
                            let color = "Card-\(index)"
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 34, height: 34)
                                .overlay{
                                    Circle()
                                        .fill(Color(color))
                                        .frame(width: 30, height: 30)
                                        .overlay(content: {
                                            
                                            if (color == habitModel.habitColor &&
                                                (color == "Card-5" || color == "Card-3")){
                                                Image(systemName: "checkmark")
                                                    .font(.caption.bold())
                                                    .foregroundColor(.black)
                                            } else {
                                                if color == habitModel.habitColor{
                                                    Image(systemName: "checkmark")
                                                        .font(.caption.bold())
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        })}
                                .onTapGesture {
                                    habitModel.habitColor = color
                                }
                                .frame(maxWidth: .infinity)
                            
                        }
                        
                    }
                    // Add photo
//                    HStack(spacing: 10){
//                        Button{
//                            //                            ImagePicker(sourceType: .photoLibrary, selectedImage: habitModel.habitImage.)
//                        }label:{
//                            Image(systemName: "photo.artframe")
//                                .font(.title3)
//                                .foregroundColor(.white)
//                                .padding()
//
//                        }
//                    }
//
//                    .background{
//                        Circle()
//                            .fill(Color("Card-1"))
//                            .frame(width: 40, height: 40)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 20)
                    
                    // Add date strat and finish
                    
                        VStack{
                            Text("Start")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text(habitModel.startDate.formatted(date: .long, time: .omitted) )
                                .font(.system(size: 16, weight: .bold))
                                .padding()
                                .background{
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color(habitModel.habitColor))
                                        .frame(width: 130)
                                }
                                .foregroundColor(habitModel.habitColor == "Card-5" ? .black : .white)
                                .onTapGesture{
                                    habitModel.showDatePickerStart.toggle()
                                
                                }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                    
                    //                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    // ADD Color Picker
                    // ADD frequency selection
                    VStack(alignment: .leading, spacing: 6){
                        Text("Frequency")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        let weekDays = Calendar.current.weekdaySymbols
                        HStack(spacing: 10){
                            ForEach(weekDays, id: \.self){ day in
                                let index = habitModel.weekDays.firstIndex{value in
                                    return value == day
                                } ?? -1
                                Text(day.prefix(2))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(habitModel.habitColor != "Card-5" ? .white : .black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background{
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(index != -1 ? Color(habitModel.habitColor): Color("Card-1").opacity(0.4))
                                    }
                                    .onTapGesture {
                                        if (index != -1){
                                            habitModel.weekDays.remove(at: index)
                                        } else {
                                            habitModel.weekDays.append(day)
                                        }
                                    }
                            }
                        }
                        .padding(.top, 15)
                    }
                    Group {
                        
                        // Time remainder
                        HStack{
                            VStack(alignment: .leading, spacing: 6){
                                Text("Time Reminders").font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Toggle(isOn: $habitModel.isRemainderon){}
                            .labelsHidden()
                            .tint(Color(habitModel.habitColor))
                        }
                        HStack(spacing: 12){
                            Label{
                                Text(habitModel.notificationDate.formatted(date: .omitted, time: .shortened))
                            } icon : {
                                Image(systemName: "clock")
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(Color(habitModel.habitColor),
                                        in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .foregroundColor(habitModel.habitColor == "Card-5" ? .black : .white)
                            .font(.system(size: 16, weight: .bold))
                            .onTapGesture{
                                withAnimation{
                                    habitModel.showTimePicker.toggle()
                                }
                            }
                            
                            TextField("Remainder text", text: $habitModel.remainderText)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                        }
                        .opacity(habitModel.isRemainderon ? 1 : 0)
                        .frame(height: habitModel.isRemainderon ? nil : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 6){
                                Text("Set Location").font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Toggle(isOn: $habitModel.isLocationSet){}
                            .labelsHidden()
                            .tint(Color(habitModel.habitColor))
                        }
                        VStack{
                            NavigationLink(destination: SearchView(habitModel: HabitViewModel())) {
                                Label{
                                    Text("Set location")
                                } icon : {
                                    Image(systemName: "location.fill")
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(Color(habitModel.habitColor),
                                            in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .foregroundColor(habitModel.habitColor == "Card-5" ? .black : .white)
                                .font(.system(size: 16, weight: .bold))
                            }
                            VStack{
                                Text("Lat. \(String(habitModel.latitude)) N")
                                    .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Log. \(String(habitModel.logintude)) N")
                                    .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(habitModel.placeName == "" ? "Not set" : habitModel.placeName )")
                                    .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                            
     
                        }
                        .opacity(habitModel.isLocationSet ? 1 : 0)
                    }
                }
                .animation(.easeInOut, value: habitModel.isRemainderon)
                .frame(maxHeight: .infinity,alignment: .top)
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(habitModel.editHabit != nil ? "Edit Habit" : "Add Habit")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            env.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        .tint(.primary)
                        .foregroundColor(.white)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done"){
                            Task{
                                if await habitModel.addHabit(context: env.managedObjectContext){
                                    env.dismiss()
                                }
                            }
                        }
                        .tint(.primary)
                        .disabled(!habitModel.doneStatus())
                        .opacity(habitModel.doneStatus() ? 1 : 0.6)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if habitModel.deleteHabit(context: env.managedObjectContext){
                                env.dismiss()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        .opacity(habitModel.editHabit == nil ? 0 : 1)
                    }
                }
            }
            //почему не работает ignoresSafeArea()
            .overlay{
                if habitModel.showTimePicker{
                    ZStack{
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture{
                                withAnimation{
                                    habitModel.showTimePicker.toggle()
                                }
                            }
                        
                        DatePicker.init(
                            "",
                            selection: $habitModel.notificationDate,
                            displayedComponents: [.hourAndMinute]
                        )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.white))
                            }
                    }
                    .padding()
                }
            }
            .overlay{
                if habitModel.showDatePickerStart{
                    CustomDatePicker(date: $habitModel.startDate, showPicker: $habitModel.showDatePickerStart)
                }
            }
            // тут ошибка в том что он не может получать Date = nil надо изменить в view customDate.
            //            .overlay{
            //                if habitModel.showDatePickerFinish{
            //                    habitModel.finishDate = Date()
            //                    CustomDatePicker(date: $habitModel.finishDate, showPicker: $habitModel.showDatePickerFinish)
            //                }
            //            }
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

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .environmentObject(LocationManager())
    }
}
