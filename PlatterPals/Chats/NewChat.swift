import SwiftUI

struct NewChat: View {
    
    @State var userName: String = ""
    @State var message: String = ""
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ZStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.pink)
                            .frame(width: 80)
                        
                        Image(userData[userName] ?? "")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                    }
                    Text(userName)
                        .font(.largeTitle)
                    
                    TextField("Username", text: $userName)
                        .autocorrectionDisabled(true)
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(.pink)
                    
                    TextField("Write a message", text: $message)
                    Divider()
                        .frame(minHeight: 3)
                        .overlay(.pink)
                    
                    Button("Send chat") {
                        dismiss()
                    }
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
