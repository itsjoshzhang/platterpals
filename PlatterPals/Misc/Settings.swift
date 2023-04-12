import SwiftUI
import Firebase

struct Settings: View {

    @State var loggedOut = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager

    var body: some View {
        if loggedOut {
            Splash(first: true)
        } else {
            content
        }
    }
	var content: some View {
        NavigationStack {
            List(SetItem.items) { item in
            NavigationLink(value: item) {
                SetRow(title: item.title, text: item.text,
                   image: item.image)
            }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")

            .navigationDestination(for: SetItem.self) { item in
                Settings2(anchor: item.title)
                    .environmentObject(DM)
            }
            Button("Sign Out") {
                try? Auth.auth().signOut()
                loggedOut = true
            }
            .buttonStyle(.borderedProminent)
        }}}

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

                .background(.pink)
                .clipShape(Circle())
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                Text(text)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }}}}
