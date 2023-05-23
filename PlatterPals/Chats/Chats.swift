import SwiftUI

struct Chats: View {

    // ## TRACK INFO ## \\
    @State var showMaps = false
    @State var showSearch = false
    @State var chatting = [String]()

    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager

    // ## OTHER VIEWS ## \\
    var body: some View {
        if chatting.isEmpty {
            Maps()
                .environmentObject(MD)
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack(spacing: 16) {

        // ## SHOW CONVOS ## \\

        Box()
            .padding(.top, 125)
            .onTapGesture {
                showSearch = true
            }
        List {
        ForEach(chatting, id: \.self) { id in
        NavigationLink(value: id) {
            Row(id: id)
                .environmentObject(DM)
            }
        }
        // ## CONVOS LOGIC ## \\

        .onDelete(perform: delete(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        .listStyle(.plain)
        .navigationDestination(for: String.self) { id in
            Convo(id: id)
                .environmentObject(DM)
        }
        .onChange(of: DM.md().chatting) {_ in
            refresh()
        }
        }
        .navigationTitle("My Chats")
        .onAppear {
            refresh()
        }
        // ## OTHER VIEWS ## \\

        .sheet(isPresented: $showSearch) {
            Search(forProfile: false)
                .environmentObject(DM)
        }
        .sheet(isPresented: $showMaps) {
            Maps()
                .environmentObject(MD)
                .environmentObject(DM)
        }
        VStack {
        Spacer()
        Button {
            showMaps = true
        } label: {
            Glow(text: "View users nearby!")
        }
        .padding(.bottom, 125)
        }}}}

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
