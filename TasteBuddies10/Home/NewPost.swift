import SwiftUI

struct NewPost: View {
    @State private var input: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    
                    Divider()
                    Image("gnocchi")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack(spacing: 16.0) {
                        Button("Edit Image", action: {})
                            .buttonStyle(.bordered)
                        
                        Button("Upload More", action: {})
                            .buttonStyle(.bordered)
                        
                        Button("Visibility", action: {})
                            .buttonStyle(.bordered)
                    }
                    Text(input)
                    TextField("Write a caption", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Send post", action: {})
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal, 20.0)
            }
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct NewPost_Previews: PreviewProvider {
	static var previews: some View {
        NewPost()
	}
}
