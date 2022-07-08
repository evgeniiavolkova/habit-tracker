import Foundation
import CoreData

class ActivityHistoryRepository{
    
    @Published var activityHistories: [ActivityHistory] = []
    static let shared = ActivityHistoryRepository()
    
    init() {
        PersistenceController.shared.container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getActivityHistory()
        }
    }
    
    func getActivityHistory() {
        let request = NSFetchRequest<ActivityHistory>(entityName: "ActivityHistory")
        do {
            activityHistories = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }

}
