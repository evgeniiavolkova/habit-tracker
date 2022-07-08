//
//  ShortHabitRow.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 13.06.2022.
//

import SwiftUI

struct ShortHabitRow: View {
    @EnvironmentObject var habitModel: HabitViewModel
    var body: some View {
        HStack(spacing: 12){
            let letter = habitModel.title.first
            Text(String(letter ?? "T"))
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background{
                    Circle()
                        .fill(Color(habitModel.habitColor ))
                }
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)

            
            Text(habitModel.title)
                .font(.system(size: 15, weight: .black))
                .foregroundColor(Color(habitModel.habitColor ))
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 7) {

                let dateTextFormatStart = habitModel.startDate.formatted(date: .long, time: .omitted)
                Text(dateTextFormatStart)
                    .font(.callout)
                    .opacity(0.7)
                    .foregroundColor(Color(habitModel.habitColor ))
                
                
                let dateTextFormatFinish = habitModel.finishDate?.formatted(date: .long, time: .omitted)
                Text(habitModel.finishDate != nil ? dateTextFormatFinish!: "Not set" )
                    .font(.caption)
                    .opacity(0.5)
            }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
        }
    }
}

struct ShortHabitRow_Previews: PreviewProvider {
    static var previews: some View {
        ShortHabitRow().environmentObject(HabitViewModel())
    }
}
