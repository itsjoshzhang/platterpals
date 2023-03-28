// File: checked

import SwiftUI

struct ChatDM: View {
    
    @State var name = ""
    @State var text = ""
    @State var showChat = false
    @State var showCopy = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let id = DM.user(id: name).id
        NavigationStack {
            VStack(spacing: 16) {
            // TODO: call getImage() inside onAppear() in views and assign return value to local @State vars of type UIImage

                let image = DM.getImage(id: id, path: "avatars")
                RoundPic(image: image, width: 160)

                TextField("Username", text: $name)
                    .autocorrectionDisabled(true)
                Div()

                TextField("Write a message", text: $text)
                Div()

                Button("Start chat") {
                    showChat = true
                }
                .disabled(id == "")
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)

                Text("Wanna invite a friend?")
                    .foregroundColor(.secondary)

                if !showCopy {
                    Button("Copy invite link") {
                        showCopy = true
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Invite link copied!")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("New Chat")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .fullScreenCover(isPresented: $showChat) {
            Convo(id: id, text: text)
                .environmentObject(DM)
        }
    }
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM()
            .environmentObject(DataManager())
	}
}
