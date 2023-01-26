import SwiftUI

struct Chats: View {
    
    @State var showNewChat = false
    @State var showAction = false
    @State var items = ChatsItem.data
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 16.0) {
                    
                    Text("Chats")
                        .font(.largeTitle).bold()
                        .padding(.horizontal, 20.0)
                    List {
                        ForEach(items) { item in
                            if (item.user != dm.user.name) {
                                NavigationLink(value: item) {
                                    
                                    Row(user: item.user, caption: item.caption,
                                        image: dm.fetchData(name: item.user, route: true))
                                }
                            }
                        }
                        .onDelete(perform: deleteItems(atOffsets:))
                        .onMove(perform: move(fromOffsets:toOffset:))
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showAction = true
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("New chat") {
                                showNewChat = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(image: "location",
                                     route: "maps")
                        .environmentObject(dm)
                    }
                }
            }
            .navigationDestination(for: ChatsItem.self) { item in
                ChatDM(user: item.user)
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showNewChat) {
                NewChat()
                    .environmentObject(dm)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Edit chats"),
                    buttons: [
                        .destructive(Text("Delete all chats")),
                        .default(Text("Mark all as read")),
                        .cancel(Text("Cancel"))])
            }
        }
    }
}
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
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text(user)
                        .font(.headline)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }}}}}


struct Chats_Previews: PreviewProvider {
	static var previews: some View {
        Chats()
            .environmentObject(DataManager())
	}
}
