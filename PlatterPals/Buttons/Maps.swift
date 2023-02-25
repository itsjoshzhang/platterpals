import SwiftUI
import MapKit
import CoreLocationUI

struct Maps: View {
    
    @State var profile = "Josh Z"
    @State var showProfile = false
    @StateObject var viewModel = MapsData()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                
                Text("Tap on someone's pin to view their profile!")
                    .font(.headline)
                    .foregroundColor(.pink)
                
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: markers) { marker in
                        
                        MapAnnotation(coordinate: marker.coordinate) {
                            VStack {
                                Image(marker.image)
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 40, height: 40)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Image(systemName: "mappin")
                                Text(marker.user)
                                    .font(.headline)
                            }
                            .foregroundColor(.pink)
                            .onTapGesture {
                                profile = marker.user
                                showProfile = true
                            }
                            .fullScreenCover(isPresented: $showProfile) {
                                UserPage(user: profile)
                                    .environmentObject(dm)
                            }
                        }
                    }
                    LocationButton(.currentLocation) {
                        viewModel.requestAllowOnceLocationPermission()
                    }
                    .tint(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(8.0)
                    .padding(20.0)
                }
                .ignoresSafeArea()
            }
            .navigationTitle("People Near Me")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }}}}}}


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
    Marker(user: "Josh Z", image: "pfp1", coordinate: CLLocationCoordinate2D(latitude: 37.867, longitude: -122.260)),
    Marker(user: "Saira G", image: "pfp2", coordinate: CLLocationCoordinate2D(latitude: 37.868, longitude: -122.255)),
    Marker(user: "Albert Y", image: "pfp3", coordinate: CLLocationCoordinate2D(latitude: 37.874, longitude: -122.257)),
    Marker(user: "Anka X", image: "pfp4", coordinate: CLLocationCoordinate2D(latitude: 37.869, longitude: -122.265))]


class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.872, longitude: -122.259),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Maps()
            .environmentObject(DataManager())
    }
}
