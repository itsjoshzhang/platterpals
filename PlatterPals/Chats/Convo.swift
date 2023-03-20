// File: checked

import SwiftUI

struct Convo: View {
    
    var chatter: String
    @State var text = ""
    @EnvironmentObject var DM: DataManager
    
    var commit: () -> () = {}
    var blank = Text("Write a message")
    var editing: (Bool) -> () = {_ in}
    
    var body: some View {
        VStack(spacing: 16) {

            TitleBar(id: chatter)
                .environmentObject(DM)
            
            ScrollView {
                ForEach(DM.messages) { message in
                    Bubble(message: message)
                        .environmentObject(DM)
                }
            }
            HStack(spacing: 16) {
                TextField("Write a message", text: $text,
                          onEditingChanged: editing, onCommit: commit)

                Button {
                    DM.sendChat(text: text, sender: DM.user().id,
                                getter: chatter, time: Date())
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
            DM.getChats(senderID: DM.user().id, getterID: chatter)
        }
    }
}

struct Convo_Previews: PreviewProvider {
	static var previews: some View {
        Convo(chatter: "email@gmail.com")
            .environmentObject(DataManager())
	}
}
