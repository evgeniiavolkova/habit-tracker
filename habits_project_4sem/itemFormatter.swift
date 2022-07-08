//
//  itemFormatter.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 01.06.2022.
//

import Foundation
import SwiftUI

class Formatter{
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_GB")
        formatter.setLocalizedDateFormatFromTemplate("MMMMdy")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}
