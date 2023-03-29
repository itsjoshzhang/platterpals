// File: checked

import SwiftUI

struct Convo: View {
    
    var id: String
    @State var text = ""
    @State var messages = [Message]()
    
    var commit: () -> () = {}
    var blank = Text("Write a message")
    var editing: (Bool) -> () = {_ in}

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        VStack(spacing: 16) {

            TitleBar(id: id)
                .environmentObject(DM)
            
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    Bubble(message: message)
                        .environmentObject(DM)
                }
            }
            HStack(spacing: 16) {
                TextField("Write a message", text: $text,
                          onEditingChanged: editing, onCommit: commit)

                Button {
                    DM.sendChat(text: text, sender: DM.my().id,
                                getter: id, time: Date())
                    text = ""

                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background((text == "") ? .gray: .pink)
                        .cornerRadius(60)
                }
                .disabled(text == "")
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.secondary)
            .cornerRadius(60)
            .padding(10)
        }
        .onAppear {
            messages = DM.getChats(senderID: DM.my().id, getterID: id)
        }
    }
}

struct Convo_Previews: PreviewProvider {
	static var previews: some View {
        Convo(id: "joshzhang@berkeley_edu")
            .environmentObject(DataManager())
	}
}
