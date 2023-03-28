// File: checked

import SwiftUI
import PhotosUI

struct MyProfile: View {

    @State var editInfo = false
    @State var showSets = false
    @State var imageData: Data?

    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var imageItem: PhotosPickerItem?

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
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

        } else {

            // TODO: call getImage() inside onAppear() in views and assign return value to local @State vars of type UIImage

                            let image = DM.getImage(id: id, path: "avatars")
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
}
struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        MyProfile()
            .environmentObject(DataManager())
	}
}
