import SwiftUI
import FirebaseFirestoreSwift

struct Convo: View {

    var id: String
    var pad: Bool
    @State var text = ""
    @FocusState var focus: Bool
    @State var messages = [Message]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        Group {
        let myID = DM.my().id
        VStack {

        TitleBar(id: id)
            .environmentObject(DM)
            .padding(.top, pad ? -50: 16)

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
        .padding(8)
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
            getChats(myID: myID)

            if !data.chatting.contains(id) {
                data.chatting.insert(id, at: 0)
                DM.editData(data: data)
            }}}}

    func getChats(myID: String) {
        FS.collection("messages").addSnapshotListener { snap, error in
        if let snap = snap {
        messages = snap.documents.compactMap { doc -> Message? in

        if let msg = try? doc.data(as: Message.self) {
            if (msg.sender == myID && msg.getter == id ||
                msg.sender == id && msg.getter == myID) {
                return msg }}
        return nil
        }
        messages.sort {
            $0.time < $1.time
        }}}}}
