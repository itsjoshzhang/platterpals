import SwiftUI
import MapKit
import CoreLocationUI
import FirebaseFirestoreSwift

struct Maps: View {

    var text: String
    @State var locations = [Location]()

    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {
            Text(text)
                .foregroundColor(.secondary)
                .font(.headline)

        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $MD.region, showsUserLocation: true,
                annotationItems: locations) { pin in

                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: pin.lat, longitude: pin.lon)) {

                    NavigationLink(value: pin.id) {
                        MapPin(pin: pin)
                            .environmentObject(DM)
                    }}}
            .navigationDestination(for: String.self) { id in
                Profile(id: id, pad: -50)
                    .environmentObject(DM)
            }
            LocationButton(.currentLocation) {
                MD.checkLocation()
                if let c = MD.LM?.location?.coordinate {

                    DM.sendPin(pin: Location(id: DM.my().id,
                        lat: c.latitude, lon: c.longitude))
                }
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .tint(.pink)
            .padding(16)
        }
        .navigationTitle(text.hasPrefix("T") ?
                         "Near Me": "My Chats")
        .onAppear {
            getPins()
        }
        .alert(MD.alertText, isPresented: $MD.showAlert) {
            Button("OK", role: .cancel) {}
        }}}}

    func getPins() {
        FS.collection("mapPins").addSnapshotListener { snap,_ in
        if let snap = snap {

        locations = snap.documents.compactMap { doc -> Location? in
        if let pin = try? doc.data(as: Location.self) {
            if DM.my().id != pin.id {
                return pin
            }
        }
        return nil
        }}}}}

struct Location: Identifiable, Hashable, Codable {
    let id: String
    let lat: Double
    let lon: Double
    var time = Date()
}

struct MapPin: View {

    var pin: Location
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        VStack(spacing: 0) {

            Text(getTime(pin.time))
                .font(.headline)
            RoundPic(width: 50, image: image)

            Image(systemName: "pin.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
        .frame(maxWidth: UIwidth)
        .foregroundColor(.pink)
        .padding(.bottom, 80)
        .onAppear {
            getImage(path: "avatars")
        }
    }
    func getImage(path: String) {
        let SR = SR.child("\(path)/\(pin.id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
            if let data = data {
                image = UIImage(data: data)
            }}}

    func getTime(_ date: Date) -> String {
        let cal = Calendar.current.dateComponents(
            [.day, .hour, .minute], from: date, to: Date())

        let day = cal.day ?? 0
        if day > 31 {
            return ""
        } else if day > 0 {
            return "\(day) day"
        } else if let hrs = cal.hour, hrs > 0 {
            return "\(hrs) hr"
        } else if let min = cal.minute, min > 0 {
            return "\(min) min"
        } else {
            return "Now"
        }}}

class MapsData: NSObject, ObservableObject, CLLocationManagerDelegate {

    var LM: CLLocationManager?
    @Published var alertText = ""
    @Published var showAlert = false
    @Published var locatable = false

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.8715, longitude: -122.260),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016))

    override init() {
        super.init()
        checkLocation()
    }
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            LM = CLLocationManager()
            LM?.delegate = self
            locatable = true
        }
    }
    private func checkAuthorization() {
        guard let LM = LM else { return }
        switch LM.authorizationStatus {

        case .notDetermined:
            LM.requestWhenInUseAuthorization()
        case .restricted, .denied:
            alertText = "Your location has been disabled in Settings."
            showAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center:
                LM.location!.coordinate, span: region.span)
        @unknown default:
            return
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
