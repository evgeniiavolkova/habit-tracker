//
//  SearchView.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 06.06.2022.
//

import SwiftUI
import MapKit

struct SearchView: View {
    
    @StateObject var locationManager: LocationManager = .init()
    
    @StateObject var habitModel: HabitViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.self) var env
    
    @State var navigationTag: String?

    var body: some View {
        VStack{
            HStack(spacing: 15){
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label :{
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Color("Card-1"))
                }
                Text("Search location")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("Card-1"))
                    .font(.title3)
                // add locationManager
                TextField("Find location here", text: $locationManager.searchText )
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.gray)
            }
            .padding(.vertical, 10)
            
            if let places = locationManager.fetchedPlaces,!places.isEmpty{
                List{
                    ForEach(places, id: \.self){ place in
                        Button{
                            
                            if let coordinate = place.location?.coordinate{
                                locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                locationManager.addDraggablePin(coordinate: coordinate)
                                locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                            }
                            navigationTag = "MAPVIEW"
                            
                            
                        }label:{
                            HStack(spacing: 15){
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color("Card-2"))

                                VStack(alignment: .leading, spacing: 6){
                                    Text(place.name ?? "")
                                        .font(.title3.bold())

                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(Color("Card-2"))
                                }
                            }
                        }

                    }
                }.listStyle(.plain)
            }
            else {
                Button{
                   
                    if let coordinate = locationManager.userLocation?.coordinate{
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDraggablePin(coordinate: coordinate)
                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        navigationTag = "MAPVIEW"
                    }
                    
                } label: {
                    Label{
                        Text("Use current Loc.")
                    }icon: {
                        Image(systemName: "location.circle.fill")
                    }
                    .foregroundColor(Color("Card-1"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationBarHidden(true)
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .background{
            NavigationLink(tag: "MAPVIEW", selection: $navigationTag){
                MapViewSelection()
                    .environmentObject(locationManager)
                    .navigationBarHidden(true)
            } label: {}
            .labelsHidden()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(habitModel: HabitViewModel())
    }
}

struct MapViewSelection: View{
    @EnvironmentObject var habitModel: HabitViewModel
    @Environment(\.self) var env
    
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View{
        ZStack{
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)

            

            if let place = locationManager.pickedPlaceMark{
                VStack(spacing: 15){
                    Text("Confirm Location")
                        .font(.title2.bold())
                    
                    HStack(spacing: 15){
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.vertical,10)
                    
                    Button {
                        habitModel.logintude = locationManager.pickedPlaceMark?.location?.coordinate.longitude ?? 0.0
                        print("MENDELU \( habitModel.logintude) - logintude")
                        
                        habitModel.latitude = locationManager.pickedPlaceMark?.location?.coordinate.latitude ?? 0.0
                        print("MENDELU \( habitModel.latitude) - latitude")
                        
                        print("Name: \(place.name ?? "")")
                        // сдлеать функционалиту чтобы автоматически добавляла в ебанные коре дата
                        habitModel.placeName = place.name ?? ""
                        locationManager.searchText = place.name ?? ""
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,12)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color("Card-2"))
                            }
                            .foregroundColor(.white)
                    }

                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(scheme == .dark ? .black : .white)
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity,alignment: .bottom)
            }
        }
        .onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}


struct MapViewHelper: UIViewRepresentable{
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
