import SwiftUI

struct Chats: View {

    @State var idList = [String]()
    @State var showChatDM = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                List {

                ForEach(idList, id: \.self) { id in
                    NavigationLink(value: id) {
                        Row(id: id).environmentObject(DM)
                    }
                }
                .onDelete(perform: deleteItems(atOffsets:))
                .onMove(perform: move(fromOffsets:toOffset:))
                }
                .listStyle(.plain)
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(path: 1, image: "location")
                        .environmentObject(DM)
                    }
                }
            }
            .navigationTitle("Chats")
            .onAppear {
                let data = DM.data(id: DM.my().id)

                for id in data.chatting {
                    idList.append(id)
                }
            }
            .navigationDestination(for: User.self) { user in
                Convo(id: user.id)
                    .environmentObject(DM)
            }
            .toolbar {
                ToolbarItem {
                    Button("New Chat") {
                        showChatDM = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showChatDM) {
                ChatDM()
                    .environmentObject(DM)
            }
        }
    }
    func deleteItems(atOffsets offsets: IndexSet) {
        idList.remove(atOffsets: offsets)
    }
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        idList.move(fromOffsets: source, toOffset: destination)
    }
}

struct Row: View {

    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {
            RoundPic(image: image, width: 80)

            VStack(alignment: .leading, spacing: 16) {
                Text(DM.user(id: id).name)
                    .font(.headline)

                Text("Active today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
    }
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}
}
struct Chats_Previews: PreviewProvider {
	static var previews: some View {
        Chats()
            .environmentObject(DataManager())
	}
}
