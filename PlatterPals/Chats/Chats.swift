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
            let data = DM.data(id: DM.my().id)
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
        .listStyle(.plain)
        }
        }
        // ## CONVOS LOGIC ## \\

        .navigationTitle("Chats")
        .onAppear {
            chatting = data.chatting
        }
        .sheet(isPresented: $showSearch) {
            Search(showProf: false)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func delete(atOffsets offsets: IndexSet) {
        chatting.remove(atOffsets: offsets)

        var my = DM.data(id: DM.my().id)
        my.chatting = chatting

        DM.editData(id: my.id, fo: my.favFoods, us: my.favUsers,
                    ch: my.chatting, bl: my.blocked)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        chatting.move(fromOffsets: start, toOffset: end)
    }
}
