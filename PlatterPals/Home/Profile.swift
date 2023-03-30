import SwiftUI
import PhotosUI
import FirebaseStorage

struct MyProfile: View {

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

            ZStack {
                ScrollView {
                VStack(spacing: 16) {

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

            } else {
                RoundPic(image: image, width: 160)

                Button("Edit Info") {
                    editInfo = true;
                }
                .buttonStyle(.borderedProminent)
                }

                Text("\(DM.my().name)'s favorite foods:")
                .font(.headline)
                .padding(.horizontal, 20)

                Update(id: id)
                }
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(path: 3, image: "square.and.arrow.up")
                            .environmentObject(DM)
                    }
                }
            }
            .navigationTitle("My Profile")
            .onAppear {
                getImage(id: DM.my().id, path: "avatars")
            }

            .toolbar {
                ToolbarItem {
                    Button("Settings") {
                        showSets = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showSets) {
                Settings()
                    .environmentObject(DM)
            }
        }
    }
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}
}

struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        MyProfile()
            .environmentObject(DataManager())
	}
}
