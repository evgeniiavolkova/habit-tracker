//
//  CustomTabBar.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 13.06.2022.
//

import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    
    var body: some View {
        
        GeometryReader{proxy in
            HStack(spacing: 0){
                ForEach(Tab.allCases,id: \.rawValue){tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)){
                            currentTab = tab
                        }
                    } label: {
                        Image(tab.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color("Card-1") : .gray)
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 30)
        .padding(.bottom,10)
        .padding([.horizontal,.top])
    }
}



struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
