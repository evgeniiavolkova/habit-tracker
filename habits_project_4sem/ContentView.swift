//
//  ContentView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 31.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    @State var currentTab: Tab = .editList
    
    var body: some View {
        VStack(spacing: 0){
            
            TabView(selection: $currentTab){
                Home()
                    .tag(Tab.editList)
                HabitsListView()
                    .tag(Tab.habitList)
            }
            CustomTabBar(currentTab: $currentTab)
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension View{
    func applyBG()->some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color("Card-3")
                    .ignoresSafeArea()
            }
    }
}

