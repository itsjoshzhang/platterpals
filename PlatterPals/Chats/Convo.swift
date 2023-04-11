import SwiftUI
import FirebaseFirestoreSwift

struct Convo: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var text = ""
    @State var messages = [Message]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        ZStack {
            let myID = DM.my().id
        Back()
        VStack(spacing: 16) {

        // ## CHATS LOGIC ## \\

        TitleBar(id: id)
            .environmentObject(DM)
            .padding(.top, 48)

        ScrollView {
            ForEach(messages) { message in
                Bubble(message: message)
                    .environmentObject(DM)
            }
        }
        HStack(spacing: 16) {
            TextField("Write a message", text: $text)

            Button {
                DM.sendChat(text: text, sender: myID, getter: id,
                            time: Date())
                text = ""

            // ## MODIFIERS ## \\

            } label: {
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .cornerRadius(60)
                    .background(.pink)
                    .foregroundColor(.white)
            }
            .disabled(text == "")
        }
        .padding(16)
        .background(.secondary.opacity(0.25))
        .cornerRadius(32)
        .padding(.horizontal, 16)
        }
        .onAppear {
            getChats(sender: myID, getter: id)
        }}}

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
