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


struct EditProf: View {

    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var image: UIImage?

    @State var editInfo = false
    @State var showSets = false
    @State var imageData: Data?
    @State var imageItem: PhotosPickerItem?

    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
            let id = DM.my().id

            if editInfo {
                if let data = imageData {
                    RoundPic(image: UIImage(data: data), width: 160)
                } else {
                    RoundPic(image: nil, width: 160)
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
                TextField("Change username", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Write a new bio", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Location", selection: $city) {
                    ForEach(cityList, id: \.self) { city in
                        Text(city)
                    }
                }

                Button("Save Edits") {
                    if let data = imageData {
                        DM.putImage(image: UIImage(data: data)!, path: "avatars")
                    }
                    DM.editUser(id: id, name: name, text: text, city: city,
                                views: DM.my().views)
                    editInfo = false
                }
                .disabled(name == "" && text == "")
                .buttonStyle(.borderedProminent)

                Button("Cancel") {
                    editInfo = false
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
