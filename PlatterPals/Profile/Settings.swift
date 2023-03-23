// File: checked

import SwiftUI
import Firebase

struct Settings: View {

    @State var loggedOut = false
	@State var items = SetItem.data
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager
	
	var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(value: item) {
                    SetRow(title: item.title, text: item.text, image: item.image)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(for: SetItem.self) { item in
                Settings2(anchor: item.title)
                    .environmentObject(DM)
            }
            .fullScreenCover(isPresented: $loggedOut) {
                Splash(first: true)
            }
            Button("Log out") {
                try? Auth.auth().signOut()
                loggedOut = !DM.loggedIn
            }
            .buttonStyle(.borderedProminent)
        }
	}
}

struct SetRow: View {
    
    var title: String
    var text: String
    var image: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(16)

                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)

                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
struct Settings_Previews: PreviewProvider {
	static var previews: some View {
        Settings()
            .environmentObject(DataManager())
	}
}
