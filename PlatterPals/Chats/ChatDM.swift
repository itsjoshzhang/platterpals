import SwiftUI

struct ChatDM: View {
    
    @State var name = ""
    @State var text = ""
    @State var image: UIImage?
    @State var showChat = false
    @State var showCopy = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let id = DM.user(id: name).id

        NavigationStack {
            VStack(spacing: 16) {
                RoundPic(width: 80, image: image)

                TextField("Username", text: $name)
                    .autocorrectionDisabled(true)
                Div()

                TextField("Write a message", text: $text)
                Div()

                Button("Start chat") {
                    showChat = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(id == "")
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

        .onChange(of: name) { _ in
            getImage(id: id, path: "avatars")
        }
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
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}
}
struct ChatDM_Previews: PreviewProvider {
	static var previews: some View {
        ChatDM()
            .environmentObject(DataManager())
	}
}
