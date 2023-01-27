import SwiftUI
import Firebase

struct Login: View {
    
    @State var email = ""
    @State var password = ""
    @State var showReset = false
    @State var showSignup = false
    
    @State var alertText = ""
    @State var showAlert = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        if (dm.user.name != "Log Out") {
            MyTabView()
                .environmentObject(dm)
        } else {
            content
        }
    }
    var content: some View {
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
                
                Button("Forgot password?") {
                    showReset = true
                }
                Button("New to PlatterPals?") {
                    showSignup = true
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
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showSignup) {
                Onboard()
                    .environmentObject(dm)
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
    @EnvironmentObject var dm: DataManager
    
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
