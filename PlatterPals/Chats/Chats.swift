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
            .padding(.top, 124)
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
            for id in data.chatting {
                if !(data.blocked.contains(id) ||
                    chatting.contains(id)) {
                    chatting.append(id)
                }}}
        .sheet(isPresented: $showSearch) {
            Search(showProf: false)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func delete(atOffsets offsets: IndexSet) {
        var data = DM.data(id: DM.my().id)
        chatting.remove(atOffsets: offsets)
        data.chatting = chatting

        DM.editData(data: data)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        chatting.move(fromOffsets: start, toOffset: end)
    }
}
