import SwiftUI
import Firebase

struct Login: View {
    
    @State var email = ""
    @State var password = ""
    @State var loggedIn = false
    
    @State var showReset = false
    @State var alertText = ""
    @State var showAlert = false
    
    @EnvironmentObject var dm: DataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                Image("logo")
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Divider()
                    .frame(minHeight: 3.0)
                    .overlay(.pink)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.pink)
                Divider()
                    .frame(minHeight: 3.0)
                    .overlay(.pink)
                
                Button("Reset password") {
                    showReset = true
                }
                Button("Log in") {
                    loginAuthentication()
                }
                .disabled(email == "" || password == "")
                .buttonStyle(.borderedProminent)
                .padding(20.0)
                
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(20.0)
            .navigationTitle("Welcome Back!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showReset) {
                Forgot()
            }
            .fullScreenCover(isPresented: $loggedIn) {
                MyTabView()
                    .environmentObject(dm)
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    loggedIn = user != nil
                }
            }
        }
    }
    func loginAuthentication() {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            if error != nil {
                alertText = error!.localizedDescription
                showAlert = true
            } else {
                dm.fetchUsers(paramID: email)
            }
        }
    }
}
struct Forgot: View {
    
    @State var email = ""
    @State var alertText = ""
    @State var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Divider()
                    .frame(minHeight: 3.0)
                    .overlay(.pink)
                
                Text("We'll email you a reset link right away!")
                    .foregroundColor(.secondary)
                Button("Submit") {
                    resetPassword()
                }
                .buttonStyle(.borderedProminent)
                .padding(20.0)
                .disabled(email == "")
                
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(20.0)
            .navigationTitle("Reset Password")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}
    
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                alertText = error!.localizedDescription
                showAlert = true
            } else {
                dismiss()
            }
        }
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(DataManager())
    }
}
