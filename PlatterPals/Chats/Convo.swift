import SwiftUI
import FirebaseFirestoreSwift

struct Convo: View {

    // ## SETUP VIEW ## \\
    var id: String
    var padding: Bool
    @State var text = ""
    @FocusState var focus: Bool
    @State var messages = [Message]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        Group {
        let myID = DM.my().id
        VStack {

        // ## CHATS LOGIC ## \\

        TitleBar(id: id)
            .environmentObject(DM)
            .padding(.top, padding ? -32: 0)

        ScrollView {
            ForEach(messages) { msg in
                let date = (msg == messages.first)
                let time = (msg == messages.last)
                Bubble(message: msg, showDate: date, showTime: time)
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
            let msg = Message(text: text, sender: myID, getter: id)
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
        .background {
            Back()
        }
        .onTapGesture {
            focus = false
        }
        .onAppear {
            focus = true
            var data = DM.md()
            getChats(sender: myID)

            if !(data.chatting.contains(id) || id.isEmpty) {
                data.chatting.insert(id, at: 0)
                DM.editData(data: data)
            }}}}

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
