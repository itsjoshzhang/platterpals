import SwiftUI

struct NewChat: View {
    
    @State var user: String = ""
    @State var message: String = ""
    @State var showChat = false
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if showChat {
            withAnimation {
                ChatDM(user: user, message: message)
            }
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ZStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.pink)
                            .frame(width: 80)
                        
                        Image(userData[user] ?? "")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                    }
                    Text("\(user) ")
                        .font(.largeTitle)
                    
                    TextField("Username", text: $user)
                        .autocorrectionDisabled(true)
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(.pink)
                    
                    TextField("Write a message", text: $message)
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(.pink)
                    
                    Button("Send chat") {
                        showChat = true
                    }
                    .disabled((userData[user] ?? "") == "")
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 20.0)
                    
                    Text("Know someone who's not on the app yet?")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Send invite link") {
                        showAction = true
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal, 20.0)
            }
            .navigationTitle("New Chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Send invite link"),
                    buttons: [
                    .destructive(Text("Copy link to clipboard")),
                    .default(Text("Send as text message")),
                    .cancel(Text("Cancel"))]
                )}}}}


struct NewChat_Previews: PreviewProvider {
	static var previews: some View {
        NewChat()
	}
}
