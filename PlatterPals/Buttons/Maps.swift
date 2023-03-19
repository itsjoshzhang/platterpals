// File: checked
// TODO: updating location & user markers

import SwiftUI
import MapKit
import CoreLocationUI

struct Maps: View {
    
    @State var showUser = false
    @Environment(\.dismiss) var dismiss
    @StateObject var mapsData = MapsData()
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Text("Tap a pin to view a profile")
                    .font(.headline)
                    .foregroundColor(.pink)
                
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: $mapsData.region, showsUserLocation: true, annotationItems: markers) { marker in
                        
                        MapAnnotation(coordinate: marker.coord) {
                            VStack {
                                Image(marker.image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                Image(systemName: "mappin")
                                Text(marker.user)
                                    .font(.headline)
                                    .foregroundColor(.pink)
                            }
                            .onTapGesture {
                                showUser = true
                            }
                            .fullScreenCover(isPresented: $showUser) {
                                UserProf(user: marker.user)
                                    .environmentObject(DM)
                            }
                        }
                    }
                    LocationButton(.currentLocation) {
                        mapsData.requestLocation()
                    }
                    .tint(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(20)
                }
                .ignoresSafeArea()
            }
            .navigationTitle("People Near Me")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Marker: Identifiable {
    var id = UUID()
    var user: String
    var image: String
    var coord: CLLocationCoordinate2D
}

var markers = [
    Marker(user: "Josh Z", image: "pfp1", coord: CLLocationCoordinate2D(
        latitude: 37.867, longitude: -122.260)),
    
    Marker(user: "Saira G", image: "pfp2", coord: CLLocationCoordinate2D(
        latitude: 37.868, longitude: -122.255)),
    
    Marker(user: "Albert Y", image: "pfp3", coord: CLLocationCoordinate2D(
        latitude: 37.874, longitude: -122.257)),
    
    Marker(user: "Anka X", image: "pfp4", coord: CLLocationCoordinate2D(
        latitude: 37.869, longitude: -122.265))]


class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.872, longitude: -122.259),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))
        }
    }
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Maps()
            .environmentObject(DataManager())
    }
}
