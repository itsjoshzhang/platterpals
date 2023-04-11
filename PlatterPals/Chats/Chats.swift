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

        // ## SHOW CONVOS ## \\

        Box()
            .padding(.top, 124)
            .onTapGesture {
                showSearch = true
            }
        List {
        ForEach(chatting, id: \.self) { id in
        Row(id: id)
            .environmentObject(DM)
            .onTapGesture {
                nextID = id
                showConvo = true
            }
        }
        .onDelete(perform: delete(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        // ## CONVOS LOGIC ## \\

        .onChange(of: DM.md().chatting) {_ in
            refresh()
        }
        .opacity(chatting.isEmpty ? 0: 1)
        .listStyle(.plain)
        }
        }
        .navigationTitle("Chats")
        .onAppear {
            refresh()
        }
        .sheet(isPresented: $showSearch) {
            Search(showProf: false)
                .environmentObject(DM)
        }
        .fullScreenCover(isPresented: $showConvo) {
            Convo(id: nextID)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func refresh() {
        for id in DM.md().chatting {
            if !(DM.md().blocked.contains(id) ||
                chatting.contains(id)) {
                chatting.append(id)
            }}}

    func delete(atOffsets offsets: IndexSet) {
        chatting.remove(atOffsets: offsets)
        var data = DM.md()

        data.chatting = chatting
        DM.editData(data: data)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        chatting.move(fromOffsets: start, toOffset: end)
    }
}
