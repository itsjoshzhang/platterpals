import SwiftUI

struct Chats: View {

    @State var isEmpty = false
    @State var showMaps = false
    @State var showMatch = false
    @State var showSearch = false
    @State var chatting = [String]()

    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
        VStack {

        Box(text: "Start a new chat")
            .onTapGesture {
                showSearch = true
            }
        if isEmpty {
            Maps(text: "No chats yet? Explore below!", match: true)
                .environmentObject(MD)
                .environmentObject(DM)
        } else {
            Text("Swipe left / long press to edit.")
                .foregroundColor(.secondary)
                .padding(.bottom, -8)
                .font(.subheadline)
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
        .padding(.bottom, 70)
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
        .onChange(of: DM.md().chatting) {_ in
            getChats()
        }
        .sheet(isPresented: $showSearch) {
            Search(profile: false)
                .environmentObject(DM)
        }
        .sheet(isPresented: $showMatch) {
            Match()
                .environmentObject(DM)
        }
        .sheet(isPresented: $showMaps) {
            Maps(text: "Tap a pin to view a profile!", match: false)
                .environmentObject(MD)
                .environmentObject(DM)
        }
        if !isEmpty {
            VStack { Spacer(); HStack { Button {
                showMatch = true
            } label: {
                Glow(text: "Find me a match!")
            }
            Button {
                showMaps = true
            } label: {
                Text("Near Me")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .background(Capsule().fill(.pink))
                    .padding(.bottom, 16)
            }}}
            .padding(.horizontal, 16)
        }}}}
    
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
