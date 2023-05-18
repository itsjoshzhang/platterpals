import SwiftUI
import FirebaseFirestoreSwift

struct Convo: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var text = ""
    @FocusState var focus: Bool
    @State var messages = [Message]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        ZStack(alignment: .top) {
            let myID = DM.my().id
        VStack {

        // ## CHATS LOGIC ## \\

        TitleBar(id: id)
            .environmentObject(DM)
            .padding(.top, 10)

        ScrollView {
            ForEach(messages) { message in
                Bubble(message: message)
                    .environmentObject(DM)
            }
        }
        HStack {
        TextField("Send a message", text: $text, axis: .vertical)
            .padding(.leading, 8)
            .focused($focus)
            .lineLimit(8)
            .onTapGesture {
                focus = true
            }
        Button {
            DM.sendChat(text: text, sender: myID, getter: id,
                        time: Date())
            text = ""

        // ## MODIFIERS ## \\

        } label: {
            Image(systemName: "paperplane.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .disabled(text.isEmpty)
        }
        .padding(8)
        .background(UIgray)
        .cornerRadius(32)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        }
        .onAppear {
            getChats(sender: myID, getter: id)
            var data = DM.md()
            focus = true

            if !(data.chatting.contains(id) || id.isEmpty) {
                data.chatting.append(id)

                DM.editData(data: data)
            }}}
        .onTapGesture {
            focus = false
        }
    }
    // ## FUNCTIONS ## \\

    func getChats(sender: String, getter: String) {
        FS.collection("messages").addSnapshotListener { snap, error in
        messages = snap!.documents.compactMap { doc -> Message? in

        if let msg = try? doc.data(as: Message.self) {
            if (msg.sender == sender && msg.getter == getter) {
                return msg
            }
        }
        return nil
        }
        messages.sort {
            $0.time < $1.time
        }}}}
