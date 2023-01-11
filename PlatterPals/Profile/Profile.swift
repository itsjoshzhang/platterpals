import SwiftUI

struct Profile: View {
    
    @State var editBio = false
    @State var bioText = "I don't like writing bio's either"
    @State var showPosts = false
    @State var showAction = false
    @State var showSettings = false
    
    @State var user = "Josh Z"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        Image(userData[user]!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                            .padding(.leading, 20.0)
                        
                        VStack(alignment: .leading) {
                            Text(bioText)
                            if editBio {
                                TextField("Write a new bio", text: $bioText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    Text("Your favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Carousel(tag: user)
                    Grid()
                        .onTapGesture {
                            showPosts = true
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
            .fullScreenCover(isPresented: $showSettings) {
                Settings()
            }
            .fullScreenCover(isPresented: $showPosts) {
                ProfilePosts(user: user)
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
	}
}
