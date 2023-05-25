import SwiftUI

struct Chats: View {

    // ## SETUP VIEW ## \\
    @State var showMaps = false
    @State var showSearch = false
    @State var chatting = [String]()

    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        // ## SHOW CHATS ## \\
        Box()
            .onTapGesture {
                showSearch = true
            }
        if chatting.isEmpty {
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
            Convo(id: id, padding: true)
                .environmentObject(DM)
        }
        .onChange(of: DM.md().chatting) {_ in
            refresh()
        }}}
        .navigationTitle("My Chats")
        .background {
            Back()
        }
        .onAppear {
            refresh()
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
        if !chatting.isEmpty {
            VStack {
                Spacer()
            Button {
                showMaps = true
            } label: {
                Glow(text: "View users nearby!")
            }}}}}

    // ## FUNCTIONS ## \\

    func refresh() {
        let data = DM.md()
        for id in data.chatting {

            if !(data.blocked.contains(id) || chatting.contains(id)) {
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
