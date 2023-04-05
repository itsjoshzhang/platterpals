import SwiftUI
import PhotosUI

struct ProfHead: View {

    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
            let myID = DM.my().id
            var data = DM.data(id: myID)

        HStack {
            if showFollow {
            Button("Following") {

            if let i = data.favUsers.firstIndex(of: id) {
                data.favUsers.remove(at: i)

                editData(myID: myID, data: data)
                showFollow = false
            }
            }
            .buttonStyle(.bordered)

            } else {
                Button("Follow \(Image(systemName: "heart"))") {
                    data.favUsers.append(id)

                    editData(myID: myID, data: data)
                    showFollow = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            showFollow = data.favUsers.contains(id)
        }
    }
    }
    func editData(myID: String, data: UserData) {
        DM.editData(id: myID, fo: data.favFoods, us: data.favUsers,
                    ch: data.chatting, bl: data.blocked)
    }
}

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
            }}}}
