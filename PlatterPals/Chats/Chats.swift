import SwiftUI

struct Chats: View {

    // ## TRACK INFO ## \\
    @State var nextID = ""
    @State var showConvo = false
    @State var showSearch = false
    @State var chatting = [String]()

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        NavigationStack {
        ZStack {
        Back()

        VStack(spacing: 16) {
        Box()
            .padding(.top, 120)
            .onTapGesture {
                showSearch = true
            }
        // ## SHOW CONVOS ## \\

        List {
        ForEach(chatting, id: \.self) { id in
        Row(id: id)
            .environmentObject(DM)
            .onTapGesture {
                showConvo = true
            }
            .fullScreenCover(isPresented: $showConvo) {
                Convo(id: id)
                    .environmentObject(DM)
            }
        }
        .onDelete(perform: delete(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        .opacity(chatting.isEmpty ? 0: 1)
        .listStyle(.plain)
        }
        }
        // ## CONVOS LOGIC ## \\

        .navigationTitle("Chats")
        .onAppear {
            chatting = DM.md().chatting
        }
        .sheet(isPresented: $showSearch) {
            Search(showProf: false)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func delete(atOffsets offsets: IndexSet) {
        var data = DM.md()
        chatting.remove(atOffsets: offsets)
        data.chatting = chatting

        DM.editData(id: data.id, ff: data.favFoods, fu: data.favUsers,
                    ch: data.chatting, bl: data.blocked)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        chatting.move(fromOffsets: start, toOffset: end)
    }
}
