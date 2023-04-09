import SwiftUI

struct Chats: View {

    @State var name = ""
    @State var nextID = ""
    @State var showConvo = false
    @State var showSearch = false
    @State var idList = [String]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack(spacing: 16) {

        TextField("Search for a user:", text: $name)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 16)
            .padding(.top, 120)
            .onTapGesture {
                showSearch = true
            }
        List {
        ForEach(idList, id: \.self) { id in

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
        //.padding(.top, 110)
        }
        }
        .navigationTitle("Chats")
        .onAppear {
            let data = DM.data(id: DM.my().id)
            for id in data.chatting {

                if !idList.contains(id) {
                    idList.append(id)
                }}}
        .sheet(isPresented: $showSearch) {
            Search(showProf: false)
                .environmentObject(DM)
        }}}
    func delete(atOffsets offsets: IndexSet) {
        idList.remove(atOffsets: offsets)
    }
    func move(fromOffsets start: IndexSet, toOffset end: Int) {
        idList.move(fromOffsets: start, toOffset: end)
    }
}
