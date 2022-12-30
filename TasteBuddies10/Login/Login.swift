import SwiftUI
import Firebase

struct Login: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
        if userIsLoggedIn {
            withAnimation {
                Onboard()
            }
        } else {
            content
        }
    }
    var content: some View {
        ZStack {
            VStack(spacing: 16.0) {
                Text("Welcome")
                    .foregroundColor(.pink)
                    .font(.largeTitle).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.none)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.pink)
                    }
                Divider()
                    .frame(minHeight: 3)
                    .overlay(.pink)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.pink)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.pink)
                    }
                Divider()
                    .frame(minHeight: 3)
                    .overlay(.pink)
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                }
                .buttonStyle(.borderedProminent)
                .padding(20.0)
                
                Button {
                    login()
                } label: {
                    Text("Have an account? Log in")
                }
                .padding(20.0)
                
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
extension View {
    func placeholder <Content: View> (
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
