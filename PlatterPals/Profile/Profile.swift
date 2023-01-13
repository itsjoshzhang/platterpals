import SwiftUI

struct Profile: View {
    
    @State var bioText = ""
    @State var editBio = false
    @State var showAction = false
    @State var showSettings = false
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
                            .padding(.leading, 20.0)
                        
                        VStack(alignment: .leading) {
                            Text(dm.user.bio)
                            if editBio {
                                HStack(spacing: 0.0) {
                                    TextField("Write a new bio", text: $bioText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Button("\(Image(systemName: "checkmark.circle"))") {
                                        dm.user.bio = bioText
                                    }
                                }
                            }
                        }
                    }
                    HStack(spacing: 16.0) {
                        Button("Sync data") {
                            showAction = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Toggle("Edit bio", isOn: $editBio)
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
                    
                    Carousel(tag: "")
                    BigButton(text: "View recent posts",
                              route: "posts", user: dm.user.name)
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
            .fullScreenCover(isPresented: $showSettings) {
                Settings()
                    .environmentObject(dm)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Sync Data"),
                    buttons: [
                    .destructive(Text("Log in to DoorDash")),
                    .default(Text("Upload DoorDash data")),
                    .cancel(Text("Cancel"))]
                )}}}}


struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        Profile()
            .environmentObject(DataManager())
	}
}
