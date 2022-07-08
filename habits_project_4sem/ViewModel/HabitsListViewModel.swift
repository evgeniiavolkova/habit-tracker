//
//  HabitsListViewModel.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 15.06.2022.
//

import Foundation
import CoreData
import Combine
import SwiftUI

class HabitsListViewModel: ObservableObject {
    @Published var habitsFilterByDay: [Habit] = []
    
    private var cancellables  = Set<AnyCancellable>()
    
    func getHabitsListByWeekDay(weekday: String) {
        HabitsRepository.shared.$habitsList.map{ habits -> [Habit] in
            habits
                .compactMap { (habit) -> Habit? in
                    guard (habit.weekDays ?? [""]).contains(weekday) else { return nil }
                    return habit
                }
        }
        .sink{ [weak self] (returnedHabits) in
            self?.habitsFilterByDay = returnedHabits
        }
        .store(in: &cancellables)
    }
}
