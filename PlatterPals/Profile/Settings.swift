import SwiftUI
import Firebase

struct Settings: View {

    @State var loggedOut = false
	@State var items = SettingsItem.data
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
	
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
            }
            .navigationDestination(for: SettingsItem.self) { item in
                Settings2(anchor: item.headline)
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $loggedOut) {
                Splash()
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    withAnimation {
                        loggedOut = user == nil
                    }
                }
            }
            Button("Log out") {
                try? Auth.auth().signOut()
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
