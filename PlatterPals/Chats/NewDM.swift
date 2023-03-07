import SwiftUI

struct NewDM: View {
    
    @State var user = ""
    @State var message = ""
    @State var showChat = false
    
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16.0) {
                    
                    Image(dm.fetchData(name: user, route: true))
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 160)
                    
                    TextField("Username", text: $user)
                        .autocorrectionDisabled(true)
                    Divider()
                        .frame(minHeight: 3.0)
                        .overlay(.pink)
                    
                    TextField("Write a message", text: $message)
                    Divider()
                        .frame(minHeight: 3.0)
                        .overlay(.pink)
                    
                    Button("Send chat") {
                        showChat = true
                    }
                    .disabled(dm.fetchData(name: user, route: true) == "logo" || message == "")
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 20.0)
                    
                    Text("Want to invite a friend?")
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
            .fullScreenCover(isPresented: $showChat) {
                Convo(user: user, message: message)
                    .environmentObject(dm)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Send invite link"),
                    buttons: [
                    .destructive(Text("Copy link to clipboard")),
                    .default(Text("Send as text message")),
                    .cancel(Text("Cancel"))]
                )}}}}


struct NewDM_Previews: PreviewProvider {
	static var previews: some View {
        NewDM()
            .environmentObject(DataManager())
	}
}