import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatDM: View {
    
    var user: String
    @State var message = ""
    var db = Firestore.firestore()
    @EnvironmentObject var dm: DataManager
    @StateObject var messageData = MessageData()
    
    var commit: () -> () = {}
    var blank = Text("Write a message")
    var editing: (Bool) -> () = {_ in}
    
    var body: some View {
        VStack(spacing: 16.0) {
            TitleBar(user: user)
                .environmentObject(dm)
            
            ScrollView {
                ForEach(messageData.messages, id: \.id) { m in
                    if ((m.sender == user && m.getter == dm.user.name) ||
                        (m.sender == dm.user.name && m.getter == user)) {
                        Bubble(message: m)
                            .environmentObject(dm)
                    }
                }
            }
            HStack(spacing: 16.0) {
                TextField("Write a message", text: $message,
                          onEditingChanged: editing, onCommit: commit)
                Button {
                    sendMessage(text: message)
                    message = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10.0)
                        .background((message == "") ? .gray: .pink)
                        .cornerRadius(60.0)
                }
                .disabled(message == "")
            }
            .padding(.vertical, 10.0)
            .padding(.horizontal, 20.0)
            .background(Color(.secondarySystemFill))
            .cornerRadius(60.0)
            .padding(10.0)
        }
    }
    func sendMessage(text: String) {
        do {
            let m = Message(id: "\(UUID())", text: text,
                sender: dm.user.name, getter: self.user, time: Date())
            try db.collection("messages").document(m.id).setData(from: m)
        } catch {
            print(error)
        }
    }
}
struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var sender: String
    var getter: String
    var time: Date
}


class MessageData: ObservableObject {
    
    var db = Firestore.firestore()
    @Published var messages: [Message] = []
    @EnvironmentObject var dm: DataManager
    
    init() {
        getMessages()
    }
    func getMessages() {
        db.collection("messages").addSnapshotListener { s, error in
            self.messages = s!.documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print(error)
                    return nil
                }
            }
            self.messages.sort {
                $0.time < $1.time
            }
        }
    }
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM(user: "Josh Z")
            .environmentObject(DataManager())
	}
}
