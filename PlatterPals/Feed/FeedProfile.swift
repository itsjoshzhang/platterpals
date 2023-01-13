import SwiftUI

struct FeedProfile: View {
    
    @State var showAction = false
    @State var showNewChat = false
    @State var showFollow = false
    
    var user: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        Image(dm.fetchData(name: user, route: true))
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80.0)

                        Text(dm.fetchData(name: user, route: false))
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
                    
                    Text("\(user)'s favourite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Carousel(tag: user)
                    BigButton(text: "View recent posts",
                              route: "posts", user: user)
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
            .environmentObject(DataManager())
	}
}
