// File: checked

import SwiftUI
import PhotosUI

struct Upload: View {

    @State var imageData: Data?
    @State var text: String = ""
    @State var images = [PhotosPickerItem]()
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
                            .frame(height: UIScreen.main.bounds.height)
                    } else {
                        Image("cards")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.25)
                            .border(.pink, width: 3)
                    }
                    PhotosPicker(selection: $images, maxSelectionCount: 1,
                                 matching: .images) {
                        Label("Select Image", systemImage: "photo")
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
                    TextField("Write a bio", text: $text)
                    Div()

                    Text("Crop image to portrait for best results")
                        .foregroundColor(.pink)

                    Button("Update Profile") {
                        DM.putImage(id: DM.user().id, path: "profiles",
                            image: imageData)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(imageData == nil || text == "")
                }
            }
            .padding(20)
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
