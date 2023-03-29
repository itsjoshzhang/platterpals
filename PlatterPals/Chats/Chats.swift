import SwiftUI

struct Chats: View {

    @State var users = [User]()
    @State var images = [UIImage]()
    @State var showChatDM = false

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    List {
                        ForEach(users) { user in
                            NavigationLink(value: user) {

                                Row(name: user.name, image: images.removeFirst())
                            }
                        }
                        .onDelete(perform: deleteItems(atOffsets:))
                        .onMove(perform: move(fromOffsets:toOffset:))
                    }
                    .listStyle(.plain)
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(path: 1, image: "location")
                        .environmentObject(DM)
                    }
                }
            }
            .navigationTitle("Chats")
            .onAppear {
                let data = DM.data(id: DM.my().id)
                for id in data.chatting {

                    users.append(DM.user(id: id))
                    images.append(DM.getImage(id: id, path: "avatars"))
                }
            }
            .navigationDestination(for: User.self) { user in
                Convo(id: user.id)
                    .environmentObject(DM)
            }
            .toolbar {
                ToolbarItem {
                    Button("New Chat") {
                        showChatDM = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showChatDM) {
                ChatDM()
                    .environmentObject(DM)
            }
        }
    }
    func deleteItems(atOffsets offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

struct Row: View {

    var name: String
    var image: UIImage

    var body: some View {
        HStack(spacing: 16) {
            RoundPic(image: image, width: 80)

            VStack(alignment: .leading, spacing: 16) {
                Text(name)
                    .font(.headline)

                Text("Active today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
struct Chats_Previews: PreviewProvider {
	static var previews: some View {
        Chats()
            .environmentObject(DataManager())
	}
}
