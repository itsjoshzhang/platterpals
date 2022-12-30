import SwiftUI

struct NewChat: View {
    
    @State private var input: String = ""
    @State private var input2: String = ""
    @State private var showAction = false
    @Environment(\.dismiss) private var dismiss
    
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
                        
                        Image(input)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                    }
                    Text(input)
                        .font(.largeTitle)
                        .padding(.horizontal, 20.0)
                    
                    TextField("Username", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20.0)
                    
                    TextField("Send a chat", text: $input2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20.0)
                    
                    Button("Send chat") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("Know someone who's not here yet? Send them an invite link!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(20.0)
                    
                    Button("Copy link") {
                        showAction = true
                    }
                    .buttonStyle(.bordered)
                }
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
                ActionSheet(title: Text("Invite people"),
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
