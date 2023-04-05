import SwiftUI
import PhotosUI

struct Upload: View {

    @State var text: String = ""
    @State var imageData: Data?
    @State var imageItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    if let data = imageData, let image =
                        UIImage(data: data) {

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIheight)
                    } else {
                        Image("cards")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.25)
                            .border(.pink, width: 3)
                    }
                    PhotosPicker("Upload Picture", selection: $imageItem,
                                 matching: .images)
                    .buttonStyle(.bordered)

                    .onChange(of: imageItem) { _ in
                        imageItem?.loadTransferable(type: Data.self) { result in

                            switch result {
                            case .success(let data):
                                imageData = data
                            case .failure(_):
                                return
                            }
                        }
                    }
                    TextField("Write a bio", text: $text)
                    Div()

                    Text("Crop image to portrait for best results")
                        .foregroundColor(.pink)

                    Button("Update Profile") {
                        DM.putImage(image: UIImage(data: imageData!)!, path: "profiles")
                        dismiss()
                    }
                    .disabled(imageData == nil || text == "")
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
            .navigationTitle("Update Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}
