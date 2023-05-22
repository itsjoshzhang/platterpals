import SwiftUI
import MapKit
import CoreLocationUI

struct Maps: View {

    @StateObject var mapsData = MapsData()
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {
            Text("Tap a pin to view a profile!")
                .foregroundColor(.secondary)

        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapsData.region,
                showsUserLocation: true)

            LocationButton(.currentLocation) {
                mapsData.requestLocation()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .tint(.pink)
            .padding(16)
        }
        .navigationTitle("Near Me")
        }}}}

class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.872, longitude: -122.259),
    span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))
    
    var LM = CLLocationManager()
    
    override init() {
        super.init()
        LM.delegate = self
    }
    func requestLocation() {
        LM.requestWhenInUseAuthorization()
        LM.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        let location = locations.first
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location?.coordinate
                ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(
                latitudeDelta: 0.016, longitudeDelta: 0.016))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError
                         error: Error) {
        print(error.localizedDescription)
    }
}
