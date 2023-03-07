import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct Upload: View {
    
    @State var imageData: Data?
    @State var caption: String = ""
    @State var images: [PhotosPickerItem] = []
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16.0) {
                    
                    if let data = imageData, let uiimage =
                        UIImage(data: data) {
                        
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                    } else {
                        Image("cards")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.25)
                            .border(.pink, width: 3.0)
                    }
                    PhotosPicker(selection: $images, maxSelectionCount: 1,
                                 matching: .images) {
                        Label("Choose Image", systemImage: "photo")
                    }
                     .buttonStyle(.bordered)
                    
                     .onChange(of: images) { _ in
                         images.first!.loadTransferable(type: Data.self) {
                             result in
                             
                             switch result {
                             case .success(let data):
                                 self.imageData = data
                             case .failure(_):
                                 return
                             }
                         }
                     }
                    TextField("Write a caption", text: $caption)
                    Divider()
                        .frame(minHeight: 3.0)
                        .overlay(.pink)
                    
                    Text("Make sure to crop your image properly!")
                        .foregroundColor(.pink)
                    Button("Send update") {
                        uploadImage()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(imageData == nil || caption == "")
                }
            }
            .padding(20.0)
            .navigationTitle("Update Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Upload_Previews: PreviewProvider {
	static var previews: some View {
        Upload()
            .environmentObject(DataManager())
	}
}
