//
//  HabitViewModel.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 02.06.2022.
//

import SwiftUI
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    
    //добавить фильтрацию дня
    //view only habits for today
    @Published var filteredHabits: [Habit]?
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()

    @Published var addNewhabit: Bool = false
    
    @Published var title: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var notificationDate: Date = Date()
    @Published var startDate: Date = Date()
    @Published var finishDate: Date? = nil
    @Published var isRemainderon: Bool = false
    @Published var remainderText: String = ""
    @Published var logintude: Double = 0.0
    @Published var latitude: Double = 0.0
    @Published var countDone = 0
    
    @Published var habitImage: UIImage? = nil
    @Published var isLocationSet: Bool = false
    
    @Published var placeName: String = ""
    
    // to show time picker for notofication
    @Published var showTimePicker: Bool = false
    @Published var showDatePickerStart: Bool = false
    @Published var showDatePickerFinish: Bool = false
    
    @Published var editHabit: Habit?
    
    @Published var notificationAccess: Bool = false
    
    init(){
        requestNotificationAccess()
        fetchCurrentWeek()
    }
    // достать актульную неделю
    func fetchCurrentWeek(){
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (0..<7).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append(weekday)
            }
        }
    }
    
    func isToday(date: Date)->Bool{
        
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func extractDate(date: Date,format: String)->String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    func addHabit(context: NSManagedObjectContext) async->Bool{
        
        var habit: Habit!
        if let editHabit = editHabit {
            habit = editHabit
            // Removing All Pending Notifications
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notoficationDs ?? [])
        }else{
            habit = Habit(context: context)
        }
        
        habit.title = title
        habit.habitColor = habitColor
        habit.remainderText = remainderText
        habit.weekDays = weekDays
        habit.notificationDate = notificationDate
        habit.startDate = startDate
        habit.finishDate = finishDate
        habit.habitDescription = habitDescription
        habit.isRemainderOn = isRemainderon
        habit.notoficationDs = []
        habit.latitude = latitude
        habit.logitude = logintude
        habit.isLocationSet = isLocationSet
        habit.placeName = placeName
        habit.countDone = Int64(countDone)
        
        
        if isRemainderon{
            
            if let ids = try? await scheduleNotification(){
                habit.notoficationDs = ids
                if let _ = try? context.save(){
                    HabitsRepository.shared.getHabitList()
                    return true
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
            }
        }else{
            
            if let _ = try? context.save(){
                HabitsRepository.shared.getHabitList()
                return true
            }
        }
        return false
    }
    
    func scheduleNotification()async throws->[String]{
        let content = UNMutableNotificationContent()
        content.title = "Habit Remainder"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        // scheduled ids
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        for weekDay in weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: notificationDate)
            let min = calendar.component(.minute, from: notificationDate)
            let day = weekdaySymbols.firstIndex{ currentDay in
                return currentDay == weekDay
            } ?? -1
            if day != -1 {
                var components = DateComponents()
                components.hour = hour
                components.minute = min
                components.weekday = day + 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
                
                notificationIDs.append(id)
            }
            
        }
        
        return notificationIDs
    }
    
    func resetData() {
        title = ""
        habitDescription = ""
        habitColor = "Card-1"
        weekDays = []
        isRemainderon = false
        notificationDate = Date()
        remainderText = ""
        editHabit = nil
        logintude = 0.0
        latitude = 0.0
        isLocationSet = false
        placeName = ""
        countDone = 0
    }
    
    func restoreEditData(){
        if let editHabit = editHabit {
            habitDescription = editHabit.habitDescription ?? ""
            title = editHabit.title ?? ""
            habitColor = editHabit.habitColor ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            isRemainderon = editHabit.isRemainderOn
            notificationDate = editHabit.notificationDate ?? Date()
            remainderText = editHabit.remainderText ?? ""
            logintude = editHabit.logitude
            latitude = editHabit.latitude
            isLocationSet = editHabit.isLocationSet
            placeName = editHabit.placeName ?? ""
            countDone = Int(editHabit.countDone)
        }
    }
    
    func doneStatus() -> Bool {
        let remainderStatus = isRemainderon ? remainderText == "" : false
        
        if title == "" || weekDays.isEmpty || remainderStatus{
            return false
        }
        return true
    }
    
    func deleteHabit(context: NSManagedObjectContext)->Bool{
        if let editHabit = editHabit {
            if editHabit.isRemainderOn{
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notoficationDs ?? [])
            }
            context.delete(editHabit)
            if let _ = try? context.save(){
                return true
            }
        }
        
        return false
    }
    func createActivityHistoryRecord(){
        
    }
    
    func doneHabit() {
        countDone = countDone + 1
    }
    
}

