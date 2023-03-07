import SwiftUI

struct UserProf: View {
    
    @State var showAction = false
    @State var showNewDM = false
    @State var showFollow = false
    @State var showUpdates = false
    
    var user: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        Image(dm.fetchData(name: user, route: true))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80.0)
                            .clipShape(Circle())
                        
                        Text(dm.fetchData(name: user, route: false))
                    }
                    .padding(.horizontal, 20.0)
                    
                    HStack(spacing: 16.0) {
                        if showFollow {
                            Button("Following") {
                                showFollow = false
                            }
                            .buttonStyle(.bordered)
                        } else {
                            Button("Follow \(Image(systemName: "heart"))") {
                                showFollow = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Button("Notifications") {
                            showAction = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 20.0)
                    
                    Text("\(user)'s favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Image("cards")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.5)
                        .onTapGesture {
                            showUpdates = true
                        }
                }
            }
            .navigationTitle(user)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send chat") {
                        showNewDM = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showNewDM) {
                Convo(user: user)
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showUpdates) {
                Selfie(name: user)
                    .environmentObject(dm)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"),
                    buttons: [
                    .destructive(Text("Block this user")),
                    .default(Text("Hide my profile")),
                    .cancel(Text("Cancel"))]
                )}}}}


struct UserProf_Previews: PreviewProvider {
	static var previews: some View {
        UserProf(user: "Josh Z")
            .environmentObject(DataManager())
	}
}
