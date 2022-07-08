//
//  HabitsRepository.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 15.06.2022.
//

import Foundation
import CoreData

class HabitsRepository{
    
    private let entityName: String = "Habit"
    @Published var habitsList: [Habit] = []
    static let shared = HabitsRepository()
    
    init() {
        PersistenceController.shared.container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getHabitList()
        }
    }
    
    func getHabitList() {
        let request = NSFetchRequest<Habit>(entityName: entityName)
        do {
            habitsList = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
}
