// File: checked

import SwiftUI

struct Chats: View {

    @State var convos = [User]()
    @State var showChatDM = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {

                    List {
                        ForEach(convos, id: \.self) { user in
                            NavigationLink(value: user) {

            // TODO: call getImage() inside onAppear() in views and assign return value to local @State vars of type UIImage

                                let image = DM.getImage(id: user.id, path: "avatars")
                                Row(name: user.name, image: image)
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
                    convos.append(DM.user(id: id))
                }
            }
            .navigationDestination(for: User.self) { user in
                Convo(id: user.id)
                    .environmentObject(DM)
            }
            .toolbar {
                ToolbarItem {
                    Button("New chat") {
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
        convos.remove(atOffsets: offsets)
    }
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        convos.move(fromOffsets: source, toOffset: destination)
    }
}

struct Row: View {

    var name: String
    var image: UIImage

    var body: some View {
        HStack(spacing: 16) {

            RoundPic(image: image, width: 60)

            VStack(alignment: .leading, spacing: 5) {
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
