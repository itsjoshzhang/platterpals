import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatDM: View {
    
    var user: String
    @State var message = ""
    @StateObject var messageData = MessageData()
    
    var blank = Text("Write a message")
    var editing: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        VStack(spacing: 16.0) {
            TitleBar(user: user)
            
            ScrollView {
                ForEach(messageData.messages, id: \.id) { message in
                    Bubble(message: message)
                }
            }
            ZStack(alignment: .leading) {
                if message.isEmpty {
                    blank.opacity(0.25)
                        .padding(.horizontal, 30.0)
                }
                HStack(spacing: 16.0) {
                    TextField("", text: $message,
                              onEditingChanged: editing, onCommit: commit)
                    Button {
                        messageData.sendMessage(text: message)
                        message = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10.0)
                            .background(.pink)
                            .cornerRadius(60.0)
                    }
                }
                .padding(.vertical, 10.0)
                .padding(.horizontal, 20.0)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(60.0)
                .padding(10.0)
            }
        }
    }
}
struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var sender: Bool
    var time: Date
}


class MessageData: ObservableObject {
    
    @Published var messages: [Message] = []
    var db = Firestore.firestore()
    
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
    func sendMessage(text: String) {
        do {
            let message = Message(id: "\(UUID())",
                text: text, sender: true, time: Date())
            try db.collection("messages").document().setData(from: message)
        } catch {
            print(error)
        }
    }
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM(user: "Josh Z")
	}
}
