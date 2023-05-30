import SwiftUI

struct Chats: View {

    // ## TRACK INFO ## \\
    @State var isEmpty = false
    @State var showMaps = false
    @State var showSearch = false
    @State var chatting = [String]()

    // ## SETUP VIEW ## \\
    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
        VStack(spacing: 16) {

        // ## SHOW CHATS ## \\
        Box(text: "Start a new chat")
            .onTapGesture {
                showSearch = true
            }
        if isEmpty {
            Maps(text: "No chats yet? Explore below!")
                .environmentObject(MD)
                .environmentObject(DM)
        } else {
        List {

        ForEach(chatting, id: \.self) { id in
        NavigationLink(value: id) {
            Row(id: id)
                .environmentObject(DM)
            }
        }
        // ## MODIFIERS ## \\

        .onDelete(perform: delete(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        .listStyle(.plain)
        .navigationDestination(for: String.self) { id in
            Convo(id: id, pad: true)
                .environmentObject(DM)
        }}}
        .navigationTitle("My Chats")
        .background {
            Back()
        }
        .onAppear {
            getChats()
        }
        .onChange(of: chatting) {_ in
            getChats()
        }
        // ## OTHER VIEWS ## \\

        .sheet(isPresented: $showSearch) {
            Search(profile: false)
                .environmentObject(DM)
        }
        .sheet(isPresented: $showMaps) {
            Maps(text: "Tap a pin to view a profile!")
                .environmentObject(MD)
                .environmentObject(DM)
        }
        if !isEmpty {
            VStack {
                Spacer()
            Button {
                showMaps = true
            } label: {
                Glow(text: "Find foodies near you!")
            }}}}}}

    // ## FUNCTIONS ## \\

    func getChats() {
        let data = DM.md()
        chatting.removeAll()

        for id in data.chatting {
            if !(data.blocked.contains(id) || chatting.contains(id)) {
                chatting.append(id)
            }
        }
        isEmpty = chatting.isEmpty
    }
    func delete(atOffsets offsets: IndexSet) {
        chatting.remove(atOffsets: offsets)
        var data = DM.md()

        data.chatting = chatting
        DM.editData(data: data)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        chatting.move(fromOffsets: start, toOffset: end)
        var data = DM.md()

        data.chatting = chatting
        DM.editData(data: data)
    }
}
