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
    @FocusState var focus: Bool
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
        ZStack {
            Back()
            VStack(spacing: 16) {

                Text("PlatterPals")
                    .font(.custom("Lobster", size: 50))
                    .padding(.bottom, 24)

                Image("logo")
                    .onTapGesture {
                        focus = false
                    }
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .focused($focus)
                Div()

                SecureField("Password", text: $password)
                    .focused($focus)
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
                .foregroundColor(.white)

                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }

            }
            .foregroundColor(.pink)
            .frame(width: width - 32)

            .sheet(isPresented: $showReset) {
                Reset()
                    .environmentObject(DM)
                    .presentationDetents([.medium])
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
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Back()
                VStack(spacing: 16) {

                    TextField("Email", text: $email)
                        .foregroundColor(.pink)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Div()

                    Text("We'll send a reset link right away!")
                        .foregroundColor(.secondary)

                    Button("Send link") {
                        resetPass()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email == "")

                    .alert(alertText, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                .navigationTitle("Reset Password")
                .padding(16)
            }
        }
            }
    func resetPass() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
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
