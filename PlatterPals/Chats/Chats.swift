import SwiftUI

struct Chats: View {
    
    @State var items = ChatsItem.data
    @State var showNewChat = false
    @State var showAction = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16.0){
                    List {
                        ForEach(items) { item in
                            NavigationLink(value: item) {
                                Row(user: item.user,
                                    caption: item.caption,
                                    image: userData[item.user]!)
                            }
                        }
                        .onDelete(perform: deleteItems(atOffsets:))
                        .onMove(perform: move(fromOffsets:toOffset:))
                    }
                    .listStyle(.plain)
                    .navigationTitle("Chats")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("New Chat") {
                                showNewChat = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    VStack { Spacer()
                        HStack { Spacer()
                            CircleButton(image: "location",
                                route: "maps")
                        }
                    }
                    Button("Edit chats") {
                        showAction = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationDestination(for: ChatsItem.self) { item in
                ChatDM(user: item.user)
            }
            .fullScreenCover(isPresented: $showNewChat) {
                NewChat()
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Edit chats"),
                    buttons: [
                    .destructive(Text("Delete all chats")),
                    .default(Text("Mark all as read")),
                    .cancel(Text("Cancel"))]
            )}}}}


extension Chats {
    struct Row: View {
        
        let user: String
        let caption: String
        let image: String
        
        var body: some View {
            HStack(spacing: 16.0) {
                
                Image(image)
                    .resizable()
                    .frame(width: 55.0, height: 55.0)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(user)
                        .font(.headline)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }}}}}


struct Chats_Previews: PreviewProvider {
	static var previews: some View {
        Chats()
	}
}
