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
        VStack {

        // ## CHATS LOGIC ## \\

        TitleBar(id: id)
            .environmentObject(DM)

        ScrollView {
            ForEach(messages) { message in
                Bubble(message: message)
                    .environmentObject(DM)
            }
        }
        HStack {
        TextField("Write a message", text: $text, axis: .vertical)
            .padding(.leading, 8)
            .focused($focus)
            .lineLimit(4)
            .onTapGesture {
                focus = true
            }
        Button {
            DM.sendChat(text: text, sender: myID, getter: id,
                        time: Date())
            text = ""

        // ## MODIFIERS ## \\

        } label: {
            Image(systemName: "paperplane.fill")
                .padding(10)
                .background((text == "") ? Color.secondary:
                    Color.pink)
                .cornerRadius(32)
                .foregroundColor(.white)
        }
        .disabled(text == "")
        }
        .padding(8)
        .background(gray)
        .cornerRadius(32)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
        }
        .onAppear {
            getChats(sender: myID, getter: id)
            var chats = DM.md().chatting
            focus = true

            if !chats.contains(id) {
                chats.append(id)
                DM.editData()
            }}}
        .onTapGesture {
            focus = false
        }
    }
    // ## FUNCTIONS ## \\

    func getChats(sender: String, getter: String) {
        FS.collection("messages").addSnapshotListener { snap, error in
        messages = snap!.documents.compactMap { doc -> Message? in
        do {
            let msg = try doc.data(as: Message.self)
            if (msg.sender == sender && msg.getter == getter) {
                return msg
            }
        } catch {}
        return nil
        }
        messages.sort {
            $0.time < $1.time
        }}}}
