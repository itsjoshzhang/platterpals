import SwiftUI
import MapKit
import CoreLocationUI

struct Maps: View {
    
    @State var showProfile = false
    @StateObject var viewModel = MapsData()
    @Environment(\.dismiss) var dismiss
    
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
                                showProfile = true
                            }
                            .fullScreenCover(isPresented: $showProfile) {
                                FeedProfile(user: marker.user)
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
            }
            .padding(20.0)
            .navigationTitle("People Near Me")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }}}}}}


struct Location_Previews: PreviewProvider {
    static var previews: some View {
        Maps()
    }
}
