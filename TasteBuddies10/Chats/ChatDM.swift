import SwiftUI

struct ChatDM: View {
    
	@State private var input: String = ""
	@State private var showAction = false
    @State private var showProfile = false
	
	var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16.0) {
                HStack(spacing: 16.0) {
                    
                    Image("Saathvik")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 80)
                        .padding(.leading, 20.0)
                    
                    Text("Top 3 Favorite Foods:")
                        .font(.headline)
                }
                Carousel()
                TextField("Send a chat", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20.0)

                Button("Notifications", action: {
                    showAction = true
                })
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Josh Z.")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Profile") {
                    showProfile = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile()
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Notifications"), buttons: [
                .destructive(Text("Block this user")),
                .default(Text("Mute notifications")),
                .cancel(Text("Cancel")),
            ])
        }
    }
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM()
	}
}
