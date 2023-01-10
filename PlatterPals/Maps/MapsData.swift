import SwiftUI
import MapKit
import CoreLocationUI

struct Marker: Identifiable {
    var id = UUID()
    var user: String
    var image: String
    var coordinate: CLLocationCoordinate2D
}
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
var markers = [
    Marker(user: "Saira", image: "pfp1", coordinate: CLLocationCoordinate2D(latitude: 37.699, longitude: -121.844)),
    Marker(user: "Josh", image: "pfp2", coordinate: CLLocationCoordinate2D(latitude: 37.660, longitude: -121.841)),
    Marker(user: "Albert", image: "pfp3", coordinate: CLLocationCoordinate2D(latitude: 37.668, longitude: -121.875)),
    Marker(user: "Saathvik", image: "pfp4", coordinate: CLLocationCoordinate2D(latitude: 37.681, longitude: -121.849)),]


final class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.660, longitude: -121.876),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
