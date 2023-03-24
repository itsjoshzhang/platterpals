// File: checked

import SwiftUI
import PhotosUI

struct Myself: View {

    @State var editInfo = false
    @State var showSets = false
    @State var imageData: Data?

    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var images = [PhotosPickerItem]()

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

    if editInfo {
        if let data = imageData, let image =
            UIImage(data: data) {

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .clipShape(Circle())

            PhotosPicker(selection: $images, maxSelectionCount: 1,
                         matching: .images) {
                Label("Select image", systemImage: "photo")
            }
            .buttonStyle(.bordered)

            TextField("Change username", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Write a new bio", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Location", selection: $city) {
                ForEach(cityList, id: \.self) { city in
                    Text(city)
                }
            }
            Button("Save edits") {
                let id = DM.user().id
                DM.putImage(id: id, path: "avatars", image: imageData)

                DM.editUser(id: id, name: name, city: city)
                editInfo = false
            }
            .buttonStyle(.borderedProminent)

            Button("Cancel") {
                editInfo = false
            }
            .buttonStyle(.bordered)

        } else {
            Image(uiImage: DM.getImage(id: DM.user().id, path: "avatars"))
            .resizable()
            .scaledToFit()
            .frame(width: 80)
            .clipShape(Circle())
        }
    }
}
                    .padding(.horizontal, 20.0)

                    HStack(spacing: 16) {
                        if !editInfo {
                            Button("Edit info") {
                                editInfo = true;
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.horizontal, 20)

                    Text("\(DM.user().name)'s favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20)

                    Update(id: DM.user().id)
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(path: 3, image: "square.and.arrow.up")
                            .environmentObject(DM)
                    }
                }
            }
            .navigationTitle("Your Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
struct Myself_Previews: PreviewProvider {
	static var previews: some View {
        Myself()
            .environmentObject(DataManager())
	}
}
