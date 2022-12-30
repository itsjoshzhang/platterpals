import SwiftUI

struct Chats: View {
    
    @State var items = ChatsItem.data
    @State private var showNewChat = false
    @State private var showAction = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Row(user: item.user,
                                caption: item.caption,
                                image: Image(item.user))
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
                            route: "location")
                    }
                }
            }
            .navigationDestination(for: ChatsItem.self) { item in
                ChatDM(user: item.user)
            }
            .fullScreenCover(isPresented: $showNewChat) {
                NewChat()
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Modify all chats"),
                    buttons: [
                    .destructive(Text("Delete all chats")),
                    .default(Text("Mark all as read")),
                    .cancel(Text("Cancel"))]
            )}}}}


private extension Chats {
    
	func deleteItems(atOffsets offsets: IndexSet) {
		items.remove(atOffsets: offsets)
	}
	func move(fromOffsets source: IndexSet, toOffset destination: Int) {
		items.move(fromOffsets: source, toOffset: destination)
	}
}


extension Chats {
    struct Row: View {
        
        let user: String
        let caption: String
        let image: Image
        
        var body: some View {
            HStack(spacing: 16.0) {
                image
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
