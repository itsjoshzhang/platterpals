import SwiftUI

struct FeedProfile: View {
    
    @State var user: String
    @State var showFollow = false
    @State var showAction = false
    
    @State var showNewChat = false
    @State var showPosts = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        Image(userData[user]!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80.0)

                        Text("I don't like writing bio's")
                    }
                    .padding(.horizontal, 20.0)
                    
                    HStack(spacing: 16.0) {
                        Toggle("Follow", isOn: $showFollow)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                            .toggleStyle(.button)
                            .foregroundColor(.pink)
                        
                        Button("Notifications") {
                            showAction = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 20.0)
                    
                    Text("\(user)'s favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Carousel(tag: user)
                    Grid()
                        .onTapGesture {
                            showPosts = true
                        }
                }
            }
            .navigationTitle(user)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send a Chat") {
                        showNewChat = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showNewChat) {
                ChatDM(user: user)
            }
            .fullScreenCover(isPresented: $showPosts) {
                ProfilePosts(user: user)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"),
                    buttons: [
                    .destructive(Text("Don't show their posts")),
                    .default(Text("Don't show them my posts")),
                    .cancel(Text("Cancel"))]
                )}}}}


struct FeedProfile_Previews: PreviewProvider {
	static var previews: some View {
        FeedProfile(user: "Albert Y")
	}
}
