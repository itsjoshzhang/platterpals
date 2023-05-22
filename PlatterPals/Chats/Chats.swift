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
        NavigationLink(value: id) {
            Row(id: id)
                .environmentObject(DM)
            }
        }
        .onDelete(perform: delete(atOffsets:))
        .onMove(perform: move(fromOffsets:toOffset:))
        }
        // ## CONVOS LOGIC ## \\

        .navigationDestination(for: String.self) { id in
            Convo(id: id)
                .environmentObject(DM)
        }
        .onChange(of: DM.md().chatting) {_ in
            refresh()
        }
        .opacity(chatting.isEmpty ? 0: 1)
        .listStyle(.plain)
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
        VStack { Spacer()
        HStack { Spacer()
        Button {
            showMaps = true
        } label: {
            Glow(image: "map")
        }
        .padding(.bottom, 110)
        .padding(16)
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
struct Glow: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .resizable()
            .padding(16)
            .background(.pink)
            .clipShape(Circle())
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .shadow(color: .pink, radius: 3)
    }
}
