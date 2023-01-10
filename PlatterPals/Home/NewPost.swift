import SwiftUI
import PhotosUI

struct NewPost: View {
    
    @State var data: Data?
    @State var input: String = ""
    @State var images: [PhotosPickerItem] = []
    
    @State var ratio = false
    @State var visible = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    
                    if let data = data, let uiimage = UIImage(data: data) {
                        if ratio {
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                        } else {
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 350, height: 350)
                                .clipped()
                        }
                    } else {
                        Image("logo")
                            .border(.pink, width: 4.0)
                    }
                    
                    //*// Divider //*//
                    
                    PhotosPicker(selection: $images,
                                 maxSelectionCount: 1, matching: .images) {
                        Label("Choose Image", systemImage: "photo")
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: images) { newValue in
                        guard let item = images.first else {
                            return
                        }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                }
                            case .failure(_):
                                return
                            }
                        }
                    }
                    
                    //*// Divider //*//
                    
                    HStack(spacing: 16.0) {
                        Toggle("Original aspect ratio", isOn: $ratio)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                        Toggle("My followers only", isOn: $visible)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                    }
                    .toggleStyle(.button)
                    .foregroundColor(.pink)
                }
                TextField("Write a caption", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 20.0)
                
                Button("Send post") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20.0)
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
