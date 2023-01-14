import SwiftUI

struct Profile: View {
    
    @State var nameText = ""
    @State var bioText = ""
    @State var editInfo = false
    
    @State var showSync = false
    @State var showSettings = false
    @State var showUpdates = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        Image(dm.user.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                        
                        VStack(alignment: .leading) {
                            if editInfo {
                            VStack {
                            HStack(spacing: 16.0) {
                            TextField("New display name", text: $nameText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button("\(Image(systemName: "paperplane"))") {
                            dm.user.name = nameText
                            dm.user.bio = bioText
                            }
                            .disabled(nameText == "")
                            }
                            TextField("Write a new bio", text: $bioText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            } else {
                                Text(dm.user.bio)
                            }
                        }
                    }
                    .padding(.horizontal, 20.0)
                    HStack(spacing: 16.0) {
                        Button("Sync data") {
                            showSync = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Toggle("Edit info", isOn: $editInfo)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                            .toggleStyle(.button)
                            .foregroundColor(.pink)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("\(dm.user.name)'s favourite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Card(headline: "No favourite foods yet",
                         caption: "Add some by syncing DoorDash data!",
                         image: "logo")
                    .padding(.horizontal, 20.0)
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 160.0)
                    
                    Image("cards")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.5)
                        .onTapGesture {
                            showUpdates = true
                        }
                }
            }
            .navigationTitle("Your Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showSettings = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showSync) {
                Sync()
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showSettings) {
                Settings()
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showUpdates) {
                Updates(name: dm.user.name)
                    .environmentObject(dm)
            }
        }
    }
}
struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        Profile()
            .environmentObject(DataManager())
	}
}
