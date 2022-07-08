//
//  CustomDatePicker.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 04.06.2022.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    @Binding var showPicker: Bool
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            DatePicker("", selection: $date, displayedComponents: [.date])
                .labelsHidden()
            
            Button{
                withAnimation{
                    showPicker.toggle()
                }
            } label :{
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .padding()
                    .background(.secondary, in: Circle())
                    .foregroundStyle(.gray)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .opacity(showPicker ? 1 : 0)
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(date: .constant(Date()), showPicker: .constant(false))
    }
}
