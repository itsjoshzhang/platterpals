import SwiftUI
import Firebase

struct Signup: View {
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var image = 0

    @State var loggedIn = false
    @State var alertText = ""
    @State var showAlert = false
    @State var hasAccount = false
    
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        if loggedIn {
            withAnimation {
                MyTabView()
                    .environmentObject(dm)
            }
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                
                Image(userImages[image])
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 200)
                
                Button("Next avatar") {
                    if image == userImages.count - 1 {
                        image = 0
                    } else {
                        image += 1
                    }
                }
                .buttonStyle(.bordered)
                
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
                
                TextField("Name", text: $name)
                    .foregroundColor(.pink)
                    .autocorrectionDisabled(true)
                Divider()
                    .frame(minHeight: 3)
                    .overlay(.pink)
                
                Button("Sign up") {
                    signupAuthentication()
                }
                .disabled(email == "" || password == "" || name == "")
                .buttonStyle(.borderedProminent)
                .padding(20.0)
                
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
                
                Button("Have an account? Log in") {
                    hasAccount = true
                }
            }
            .padding(20.0)
            .navigationTitle("Let's Get Started!")
            
            .fullScreenCover(isPresented: $hasAccount) {
                Login()
                    .environmentObject(dm)
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    loggedIn = user != nil
                }
            }
        }
    }
    func signupAuthentication() {
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if error != nil {
                alertText = error!.localizedDescription
                showAlert = true
            } else {
                dm.addUser(email, name, "About me:", "pfp\(image + 1)")
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
