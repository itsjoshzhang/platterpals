import SwiftUI

struct ChatDM: View {
    
    @State var user: String
	@State var message: String = ""
	@State var showAction = false
    @State var showProfile = false
	
	var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16.0) {
                HStack(spacing: 16.0) {
                    
                    Image(userData[user]!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 80)
                        .padding(.leading, 20.0)
                    
                    Text("\(user)'s favorite foods:")
                        .font(.headline)
                }
                Button("Notifications") {
                    showAction = true
                }
                .buttonStyle(.bordered)
                .padding(.horizontal, 20.0)
                
                Carousel(tag: user)
                Section {
                    TextField("Write a message", text: $message)
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(.pink)
                    
                    Button("Send chat") {
                        // ??
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal, 20.0)
            }
        }
        .navigationTitle(user)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Profile") {
                    showProfile = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Notifications"),
                buttons: [
                .destructive(Text("Block this user")),
                .default(Text("Mute notifications")),
                .cancel(Text("Cancel"))]
            )
        }
    }
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM(user: "Saira G")
	}
}
