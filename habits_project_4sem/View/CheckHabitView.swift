//
//  CheckHabitView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 13.06.2022.
//

import SwiftUI
import MapKit

struct CheckHabitView: View {
    @EnvironmentObject var habit: HabitViewModel
    
    @Environment(\.self) var env
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    @State var ifButtonPressed: Bool = false
    
    var oneHabit: Habit
    
    func daysBetween() -> Int {
        return Calendar.current.dateComponents([.day], from: oneHabit.startDate ?? Date(), to: Date()).day!
        }
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 20){
                HStack(alignment: .center){
                    Text(Date().formatted(date: .long, time: .omitted))
                        .font(.system(size: 17, weight: .black))
                        .foregroundColor(Color("Card-1"))
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                //создать новую записа с датой
                Button{
                    habit.doneHabit()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        
                        Circle()
                            .strokeBorder(Color("Card-6"), lineWidth: 7)
                        
                    }
                    .compositingGroup()
                    .frame(width: 227.8, height: 227.8)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                }
                .overlay{
                    Image("check")
                }
                HStack(spacing: 30){
                    
                    
                    Button{
                        //
                    } label: {
                        Circle()
                            .fill(Color("Card-1"))
                            .frame(width: 77.1, height: 77.1)
                    }
                    .overlay{
                        Image(systemName: "minus")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
            .offset(y: -120)
            
            //button sheet
            
            GeometryReader{proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    
                    ZStack{
                        
                        BlurView(style: .systemThinMaterialDark)
                            .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 30))
                        
                        VStack{
                            
                            VStack{
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 4)
                                
                                Text(oneHabit.title ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .bold))
                                    .lineLimit(1)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .padding(.top, 10)
                                    .padding(.bottom, 4)
                                    .padding(.horizontal)
                                
                                Text(oneHabit.habitDescription ?? "")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .lineLimit(1)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                            }
                            .frame(height: 100)
                            
                            Divider()
                                .background(Color.white)
                            
                            // SCrollView Content....
                            ScrollView(.vertical, showsIndicators: false, content: {
                                VStack{
                                    Text("Time")
                                        .padding(.horizontal)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .bold))
                                        .padding(.bottom, 3)
                                        .padding(.top, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        HStack{
                                            VStack{
                                                Text("Start date ")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .font(.system(size: 15))
                                                    .padding(.top, 3)
                                                    .padding(.horizontal)
                                                    .opacity(0.6)
                                                Text((Formatter.init().formatter.string(from: oneHabit.startDate ?? Date())))
                                                    .lineLimit(2)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .font(.system(size: 15))
                                                    .padding(.bottom, 1)
                                                    .padding(.horizontal)
                                            }
                                        }
                                        .padding(.bottom, 10)
                                    }
                                    .padding(.top,10)
                                    .background(BlurView(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                }
                                VStack{
                                    Text("Details")
                                        .padding(.horizontal)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .bold))
                                        .padding(.bottom, 3)
                                        .padding(.top, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        Text("Addres")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.system(size: 15))
                                            .padding(.top, 3)
                                            .padding(.horizontal)
                                            .opacity(0.6)
                                        
                                        Text(oneHabit.placeName ?? "")
                                            .lineLimit(2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.system(size: 15))
                                            .padding(.bottom, 1)
                                            .padding(.horizontal)
                                        Divider()
                                            .background(Color.white)
                                            .padding(.horizontal)
                                        Text("Coordinates")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.system(size: 15))
                                            .padding(.top, 3)
                                            .padding(.horizontal)
                                            .opacity(0.6)
                                        HStack{
                                            Text("\(String(oneHabit.latitude)) N, ")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 1)
                                            Text("\(String(oneHabit.logitude)) N")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 1)
                                            Spacer()
                                        }
                                        .frame(maxWidth:.infinity, alignment: .leading)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal)
                                    }
                                    .padding(.top,10)
                                    .background(BlurView(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                    
                                    // Map
                                    BottomView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: oneHabit.latitude, longitude: oneHabit.logitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    Text("Repeat")
                                        .padding(.horizontal)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, weight: .bold))
                                        .padding(.bottom, 3)
                                        .padding(.top, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    VStack{
                                        HStack(spacing: 0){
                                            
                                            ForEach(oneHabit.weekDays ?? [], id: \.self){day in
                                                
                                                Text(day.prefix(1))
                                                    .foregroundColor(Color("Card-3"))
                                                    .font(.system(size: 13))
                                                    .padding(12)
                                                    .background{
                                                        Circle()
                                                            .fill(.white)
                                                            .opacity(0.6)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                            }
                                            
                                        }
                                        .padding(.bottom, 10)
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 15)
                                    .background(BlurView(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                    
                                    
                                }
                                .padding(.bottom)
                                .padding(.bottom,offset == -((height - 100) / 3) ? ((height - 100) / 1.5) : 0)
                            })
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                        .offset(y: height - 100)
                        .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                            
                            out = value.translation.height
                            onChange()
                        }).onEnded({ value in
                            
                            let maxHeight = height - 100
                            withAnimation{
                                
                                // Logic COnditions For Moving States...
                                // Up down or mid....
                                if -offset > 100 && -offset < maxHeight / 2{
                                    // Mid....
                                    offset = -(maxHeight / 3)
                                }
                                else if -offset > maxHeight / 2{
                                    offset = -maxHeight
                                }
                                else{
                                    offset = 0
                                }
                            }
                            
                            // Storing Last Offset..
                            // So that the gesture can contiue from the last position...
                            lastOffset = offset
                            
                        }))
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .toolbar{
            ToolbarItem{
                NavigationLink{
                    StatisticsView(daysBetween: daysBetween(), startDate: oneHabit.startDate ?? Date())
                } label: {
                    Text("Statistics")
                }
            }
        }
        
    }
    
    func onChange(){
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    // bluer
    
    struct BlurView: UIViewRepresentable {
        
        var style: UIBlurEffect.Style
        
        func makeUIView(context: Context) -> UIVisualEffectView{
            
            let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
            
            return view
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            
        }
    }
    
    // corner
    
    struct CustomCorner: Shape {
        
        var corners: UIRectCorner
        var radius: CGFloat
        
        func path(in rect: CGRect) -> Path {
            
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            
            return Path(path.cgPath)
        }
    }
}

struct CheckHabitView_Previews: PreviewProvider {
    static var habit: Habit = Habit()
    static var previews: some View {
        ContentView()
    }
}

struct BottomView : View{
    
    @State var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    @State private var trackingMode = MapUserTrackingMode.follow
    
    var body: some View{
        VStack{
            Map(coordinateRegion: $region, interactionModes: .pan, showsUserLocation: true, userTrackingMode: $trackingMode)
                .accentColor(Color(.systemPink))
        }
        .frame(width: 320, height: 240)
        .cornerRadius(13)
    }
}
