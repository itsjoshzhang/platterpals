// File: checked

import SwiftUI
import PhotosUI
import Firebase

struct Signup: View {
    
    @State var email = ""
    @State var name = ""
    @State var city = "Berkeley"
    @State var password = ""
    @State var alertText = ""
    
    @State var showAlert = false
    @State var showTerms = false
    @State var showOnboard = false
    @State var imageData: Data?
    @State var images = [PhotosPickerItem]()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        if !DM.loggedIn {
            MyTabView()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if let data = imageData, let uiimage =
                        UIImage(data: data) {
                    
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .clipShape(Circle())
                        
                    } else {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .clipShape(Circle())
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
                                imageData = data
                            case .failure(_):
                                return
                            }
                        }
                    }
                    Group {
                        TextField("Email", text: $email)
                            .foregroundColor(.pink)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(.pink)
                        
                        SecureField("Password", text: $password)
                            .foregroundColor(.pink)
                        
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(.pink)
                        
                        TextField("Username", text: $name)
                            .foregroundColor(.pink)
                            .autocorrectionDisabled(true)
                        
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(.pink)
                        
                        Picker("Location", selection: $city) {
                            ForEach(DM.cityList) {
                                Text($0)
                            }
                        }
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(.pink)
                    }
                    HStack {
                        Text("I agree to the ")
                            .foregroundColor(.secondary)
                        
                        Button("terms and EULA") {
                            showTerms = true
                        }
                    }
                    Button("How do I use PlatterPals?") {
                        showOnboard = true
                    }
                    .buttonStyle(.bordered)
                
                    Button("Sign up") {
                        signupAuth()
                    }
                    .disabled(name == "")
                    .buttonStyle(.borderedProminent)
                    
                    .alert(alertText, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                .padding(20)
                .navigationTitle("Create Account")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                .fullScreenCover(isPresented: $showOnboard) {
                    Guide()
                        .environmentObject(DM)
                }
                .fullScreenCover(isPresented: $showTerms) {
                    Terms()
                        .environmentObject(DM)
                }
            }
        }
    }
    func signupAuth() {
        for user in DM.userList {
            
            if user.name == name {
                alertText = "Username is taken."
                showAlert = true
            }
        }
        if !showAlert {
            Auth.auth().createUser(withEmail: email,
                                   password: password) { result, error in
                if error == nil {
                    DM.putImage(id: email, path: "avatars", image: imageData)
                    DM.makeUser(id: email, name: name, city: city)
                } else {
                    alertText = error!.localizedDescription
                    showAlert = true
                }}}}}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
            .environmentObject(DataManager())
    }
}
