import SwiftUI
import Firebase

struct Settings: View {
    
    @State var loggedOut = false
    @State var showAdmin = false
	@State var items = SettingsItem.data
    @EnvironmentObject var dm: DataManager
    @Environment(\.dismiss) var dismiss
	
	var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(value: item) {
                    Row(headline: item.headline,
                        caption: item.caption,
                        image: item.imageName)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("/") {
                        showAdmin = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showAdmin) {
                Admin()
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $loggedOut) {
                Splash()
            }
            Button("Log out") {
                try? Auth.auth().signOut()
                loggedOut = true
            }
            .buttonStyle(.borderedProminent)
        }
	}
}
extension Settings {
    struct Row: View {
        
        let headline: String
        let caption: String
        let image: String
        
        var body: some View {
            HStack(spacing: 16.0) {
                
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24.0, height: 24.0)
                    .padding(16.0)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text(headline)
                        .font(.headline)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }}}}}


struct Settings_Previews: PreviewProvider {
	static var previews: some View {
        Settings()
            .environmentObject(DataManager())
	}
}
