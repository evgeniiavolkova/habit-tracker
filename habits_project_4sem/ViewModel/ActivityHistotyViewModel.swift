//
//  ActivityHistotyViewModel.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 13.06.2022.
//

import SwiftUI
import CoreData
import UserNotifications

class ActivityHistoryViewModel: ObservableObject{
    @Published var recordingDate = Date()
    @Published var ifDone = false
    @Published var activityHistoryList: [ActivityHistory] = []
    static let shared = ActivityHistoryViewModel()
    
    private let entityName: String = "ActivityHistory"
    
    init(){
        PersistenceController.shared.container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getActivityHistoryList()
            print("VUTBR \(self.activityHistoryList)")
        }
    }
    
    func saveActivityHistory(context: NSManagedObjectContext, ifDone: Bool, habit: Habit) async->Bool {
        let newActibityInstance = ActivityHistory(context: context)
        newActibityInstance.recordingDate = Date()
        newActibityInstance.ifDone = ifDone
        newActibityInstance.habitHistory = habit
        do{
            try context.save()
            return true
        }catch{
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func reset() {
        recordingDate = Date()
        ifDone = false
    }
    
    func getActivityHistoryList() {
        let request = NSFetchRequest<ActivityHistory>(entityName: entityName)
        do {
            activityHistoryList = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    func checkActivityHistoryList(habitId: ObjectIdentifier) -> Bool {
        let result = activityHistoryList.contains{$0.recordingDate == Date() && $0.habitHistory?.id == habitId}
       
        return result
    }
    
    func saveWithCheck(context: NSManagedObjectContext, ifDone: Bool, habit: Habit) async->Bool {

        if !checkActivityHistoryList(habitId: habit.id){
            let newActibityInstance = ActivityHistory(context: context)
            newActibityInstance.habitHistory = habit
            newActibityInstance.recordingDate = Date()
            newActibityInstance.ifDone = ifDone
            
            do{
                try context.save()
                return true
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        } else {
            return false
        }
    }
}
    

