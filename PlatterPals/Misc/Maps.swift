import SwiftUI
import MapKit
import CoreLocationUI

struct Maps: View {

    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {
            Text("Tap a pin to view a profile!")
                .foregroundColor(.secondary)

        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $MD.region, showsUserLocation: true)
                .onAppear {
                    MD.checkLocation()
                }
            LocationButton(.currentLocation) {
                MD.requestLocation()
            }
            .cornerRadius(8)
            .tint(.pink)
            .padding(16)
        }
        .navigationTitle("Near Me")
        .alert(MD.alertText, isPresented: $MD.showAlert) {
            Button("OK", role: .cancel) {}
        }}}}}

class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {

    var LM: CLLocationManager?
    @Published var alertText = ""
    @Published var showAlert = false

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.872, longitude: -122.259),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))

    override init() {
        super.init()
        LM?.delegate = self
    }
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            LM = CLLocationManager()
            LM?.delegate = self
        } else {
            showAlert = true
        }
    }
    func requestLocation() {
        LM?.requestLocation()
    }

    func checkAuthorization() {
        guard let LM = LM else { return }
        switch LM.authorizationStatus {

        case .notDetermined:
            LM.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center:
                LM.location!.coordinate, span: region.span)
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center:
                location.coordinate, span: self.region.span)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError
                         error: Error) {
        alertText = error.localizedDescription
        showAlert = true
    }
}
