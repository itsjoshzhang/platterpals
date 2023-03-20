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
                        ForEach(convos) { user in
                        NavigationLink(value: user) {

                        Row(name: user.name, image: user.image, text:
                            "Active \(Int.random(in: 1...9)) hr ago")
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
                for id in DM.data().chatting {
                    convos.append(DM.find(id: id))
                }
            }
            .navigationDestination(for: User.self) { user in
                Convo(id: user.id)
                    .environmentObject(DM)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        DM.initLoad()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
    var image: String
    var text: String

    var body: some View {
        HStack(spacing: 16) {

            Image(image)
                .resizable()
                .frame(width: 55, height: 55)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.headline)

                Text(text)
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
