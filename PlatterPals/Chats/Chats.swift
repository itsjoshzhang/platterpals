import SwiftUI

struct Chats: View {

    @State var idList = [String]()
    @State var showChatDM = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        ZStack {
        Back()

        VStack(spacing: 16) {
        Spacer()
        List {

        ForEach(idList, id: \.self) { id in
            NavigationLink(value: id) {
                Row(id: id)
                    .environmentObject(DM)
            }
        }
        .onDelete(perform: deleteItems(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        .listStyle(.plain)
        .padding(.top, 80)
        }
        }
        .navigationTitle("Chats")
        .onAppear {
            let data = DM.data(id: DM.my().id)

            for id in data.chatting {
                if !idList.contains(id) {
                    idList.append(id)
                }
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
        idList.remove(atOffsets: offsets)
    }
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        idList.move(fromOffsets: source, toOffset: destination)
    }
}
