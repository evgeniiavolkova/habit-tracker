import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var activityHistoriesByHabit: [ActivityHistory] = []
    var habitId: ObjectIdentifier
    
    init(habitId: ObjectIdentifier) {
        self.habitId = habitId
        print("AVAST: \(habitId)")
        getActivityHistoryListByHabitId(habitId: habitId)
        print("AVAST: \(activityHistoriesByHabit.count)")
    }
    
    private var cancellables  = Set<AnyCancellable>()
    
    func getActivityHistoryListByHabitId(habitId: ObjectIdentifier) {
        ActivityHistoryRepository.shared.$activityHistories.map{ activityHistories -> [ActivityHistory] in
            activityHistories
                .compactMap { (history) -> ActivityHistory? in
                    guard let entity = activityHistories.first(where: { $0.habitHistory?.id == habitId }) else {
                        return nil
                    }
                    return entity
                }
        }
        .sink{ [weak self] (returnedHistory) in
            self?.activityHistoriesByHabit = returnedHistory
        }
        .store(in: &cancellables)
    }
    
    
}
