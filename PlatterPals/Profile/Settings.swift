import SwiftUI
import Firebase

struct Settings: View {
    
    @State var loggedOut = false
	@State var items = SettingsItem.data
    @Environment(\.dismiss) private var dismiss
	
    var body: some View {
        if loggedOut {
            withAnimation {
                Signup()
            }
        } else {
            content
        }
    }
	var content: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(value: item) {
                    Row(headline: item.headline,
                        caption: item.caption,
                        image: Image(systemName: item.imageName))
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
        let image: Image
        
        var body: some View {
            HStack(spacing: 16.0) {
                image
                    .resizable()
                    .frame(width: 24.0, height: 24.0)
                    .padding(16.0)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(headline)
                        .font(.headline)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }}}}}


struct Settings_Previews: PreviewProvider {
	static var previews: some View {
        Settings()
	}
}
