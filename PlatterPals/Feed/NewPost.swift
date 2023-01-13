import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct NewPost: View {
    
    @State var showRatio = false
    @State var invisible = false
    @State var imageData: Data?
    @State var caption: String = ""
    @State var images: [PhotosPickerItem] = []
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    
                    if let data = imageData, let uiimage = UIImage(data: data) {
                        if showRatio {
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
                    
                    
                    PhotosPicker(selection: $images,
                                 maxSelectionCount: 1, matching: .images) {
                        Label("Choose Image", systemImage: "photo")
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: images) { _ in
                        images.first!.loadTransferable(type: Data.self) { result in
                            
                            switch result {
                            case .success(let data):
                                self.imageData = data
                            case .failure(_):
                                return
                            }
                        }
                    }
                    HStack(spacing: 16.0) {
                        Toggle("Original aspect ratio", isOn: $showRatio)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                        Toggle("My followers only", isOn: $invisible)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 1.0)
                            )
                    }
                    .toggleStyle(.button)
                    .foregroundColor(.pink)
                }
                TextField("Write a caption", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 26.0)
                
                Button("Send post") {
                    uploadImage()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(imageData == nil)
            }
            .padding(.horizontal, 20.0)
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}
    
    
    func uploadImage() {
        let id = dm.user.name
        let fileRef = Storage.storage().reference().child("images/\(id)")
        fileRef.putData(imageData!, metadata: nil)
        
        let db = Firestore.firestore()
        let ref = db.collection("profiles").document(id)
        ref.setData(["user": id, "url": "profiles/\(id)", "text": caption])
    }
}


struct NewPost_Previews: PreviewProvider {
	static var previews: some View {
        NewPost()
            .environmentObject(DataManager())
	}
}
