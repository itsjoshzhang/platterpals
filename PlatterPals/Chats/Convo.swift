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
        ZStack {
            let myID = DM.my().id
            Back()
        VStack {

        // ## CHATS LOGIC ## \\

        TitleBar(id: id)
            .environmentObject(DM)
            .padding(.top, -32)

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
            let msg = Message(text: text, sender: myID, getter: id,
                              time: Date())
            DM.sendChat(msg: msg)
            text = ""

        // ## MODIFIERS ## \\

        } label: {
            Image(systemName: "paperplane.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
        }
        .disabled(text.isEmpty)
        }
        .padding(8)
        .background(UIgray)
        .cornerRadius(32)
        .padding(16)
        }
        .padding(.vertical, 110)

        .onAppear {
            getChats(sender: myID)
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

    func getChats(sender: String) {
        FS.collection("messages").addSnapshotListener { snap, error in
        if let snap = snap {
            messages = snap.documents.compactMap { doc -> Message? in

            if let msg = try? doc.data(as: Message.self) {
                if (msg.sender == sender && msg.getter == id) {
                    return msg }}
            return nil
            }
            messages.sort {
                $0.time < $1.time
            }}}}}
