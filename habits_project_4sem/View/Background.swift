//
//  Background.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 15.06.2022.
//

import SwiftUI

struct BackgroundContent: View {
    var body: some View {
        
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.6666666865348816, green: 0.3921568691730499, blue: 0.7960784435272217, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0.9058823585510254, green: 0.5529412031173706, blue: 0.7450980544090271, alpha: 1)), location: 0.270621120929718),
                .init(color: Color(#colorLiteral(red: 0.8705882430076599, green: 0.5796313881874084, blue: 0.5529412031173706, alpha: 1)), location: 0.5689336657524109),
                .init(color: Color(#colorLiteral(red: 0.9764705896377563, green: 0.8666666746139526, blue: 0.729411780834198, alpha: 1)), location: 0.8371358513832092)]),
            startPoint: UnitPoint(x: 1.1102230246251565e-16, y: 8.326672684688674e-17),
            endPoint: UnitPoint(x: 1.1119402583942715, y: 1.3807229378987198))
        
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundContent()
    }
}
