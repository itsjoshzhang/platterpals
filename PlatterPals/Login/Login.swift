// File: checked

import SwiftUI
import Firebase

struct Login: View {
    
    @State var email = ""
    @State var password = ""
    @State var alertText = ""
    @State var showAlert = false
    
    @State var showReset = false
    @State var showSignup = false
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
            VStack(spacing: 16) {
                Image("logo")
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Div()
                
                SecureField("Password", text: $password)
                    .foregroundColor(.pink)
                Div()
                
                Button("Reset password") {
                    showReset = true
                }
                Button("Create account") {
                    showSignup = true
                }
                .buttonStyle(.bordered)
                
                Button("Log in") {
                    loginAuth()
                }
                .disabled(email == "" || password == "")
                .buttonStyle(.borderedProminent)
                
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(20)
            .navigationTitle("Welcome Back!")
            
            .fullScreenCover(isPresented: $showReset) {
                Reset()
                    .environmentObject(DM)
            }
            .fullScreenCover(isPresented: $showSignup) {
                Signup()
                    .environmentObject(DM)
            }
        }
    }
    func loginAuth() {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            
            if error == nil {
                DM.initUser(id: email)
            } else {
                alertText = error!.localizedDescription
                showAlert = true
            }
        }
    }
}

struct Reset: View {
    
    @State var email = ""
    @State var alertText = ""
    @State var showAlert = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Div()
                
                Button("Send reset link") {
                    resetPass()
                }
                .buttonStyle(.borderedProminent)
                .disabled(email == "")
                
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(20)
            .navigationTitle("Reset Password")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}
    
    func resetPass() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
            if error == nil {
                alertText = "Reset link sent!"
            } else {
                alertText = error!.localizedDescription
            }
            showAlert = true
        }
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(DataManager())
    }
}
