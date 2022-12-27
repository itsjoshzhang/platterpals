import SwiftUI

struct NewChat: View {
    @State private var input: String = ""
    @State private var input2: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    
                    Image("Saira")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 250, height: 250)
                        .frame(maxWidth: .infinity)
                    
                    Text(input)
                        .font(.largeTitle)
                        .padding(.horizontal, 20.0)
                    
                    TextField("Username", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20.0)
                    
                    TextField("Send a chat", text: $input2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20.0)
                    
                    Button("Send chat", action: {})
                        .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("New Chat")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct NewChat_Previews: PreviewProvider {
	static var previews: some View {
        NewChat()
	}
}
