//
//  ColorView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 01.06.2022.
//

import SwiftUI

struct ColorView: View {
    
    @State private var bgColor = Color.red
    
    var body: some View {
        VStack {
            ColorPicker("Set the background color", selection: $bgColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor)
        .ignoresSafeArea()
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
