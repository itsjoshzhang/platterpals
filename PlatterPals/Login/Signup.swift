// TODO: keep user logged in after exiting

import SwiftUI
import PhotosUI
import Firebase

struct Signup: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var alertText = ""
    @State var city = "Berkeley"
    
    @State var showAlert = false
    @State var showTerms = false
    @State var showGuide = false
    @State var imageData: Data?
    @State var imageItem: PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        if DM.loggedIn {
            MyTabView()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
        ZStack {
        Back()
        ScrollView {
        VStack(spacing: 16) {
            Spacer(); Spacer()

            if let data = imageData {
                RoundPic(image: UIImage(data: data), width: 160)
            } else {
                RoundPic(width: 160)
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
            Group {
                TextField("Email", text: $email)
                Div()

                SecureField("Password", text: $password)
                Div()

                TextField("Username", text: $name)
                Div()
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .foregroundColor(.pink)

            HStack {
                Text("Location")
                    .foregroundColor(.pink)
                    .font(.headline)

                Picker("", selection: $city) {
                    ForEach(cityList, id: \.self) { city in
                        Text(city)
                    }
                }
                .buttonStyle(.bordered)
            }
            HStack {
                Text("I agree to the")
                    .foregroundColor(.secondary)

                Button("terms and EULA") {
                    showTerms = true
                }
            }
            Group {
                Button("PlatterPals How-To") {
                    showGuide = true
                }
                Button("Create Account") {
                    signupAuth()
                }
                .disabled(name == "" || imageData == nil)

                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .buttonStyle(.borderedProminent)
        }
        }
        }
        .navigationTitle("Create Account")
        .padding(16)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showGuide) {
            Guide()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        }
    }
    func signupAuth() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in

            if error == nil {
                DM.putImage(id: email, path: "avatars", image: imageData)
                DM.makeUser(id: email, name: name, city: city)
            } else {
                alertText = error!.localizedDescription
                showAlert = true
            }
        }
    }
}
struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
            .environmentObject(DataManager())
    }
}
