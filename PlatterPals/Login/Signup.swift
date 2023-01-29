import SwiftUI
import Firebase

struct Signup: View {
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var image = 5
    
    @State var alertText = ""
    @State var showAlert = false
    @State var showOnboard = false
    @State var showTerms = false
    @State var disabled = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                
                Image("pfp\(image)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(Circle())
                
                Button("Next avatar") {
                    if image == 5 { image = 1 } else { image += 1 }
                }
                .buttonStyle(.bordered)
                Group{
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
                    
                    TextField("Username", text: $name)
                        .foregroundColor(.pink)
                        .autocorrectionDisabled(true)
                    Divider()
                        .frame(minHeight: 3.0)
                        .overlay(.pink)
                }
                Button("How do I use PlatterPals?") {
                    showOnboard = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 20.0)
                
                HStack(spacing: 0.0) {
                    Text("By signing up, I agree to the ")
                        .foregroundColor(.secondary)
                    Button("terms") {
                        showTerms = true
                    }
                }
                Button("Sign up") {
                    signupAuthentication()
                }
                .disabled(name == "" || disabled)
                .buttonStyle(.borderedProminent)
                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
                .alert("This username is taken.", isPresented: $disabled) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(20.0)
            .navigationTitle("Let's Get Started!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showOnboard) {
                Onboard()
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showTerms) {
                Terms()
            }
        }
    }
    func signupAuthentication() {
        for user in dm.userArray {
            if name == user.name {
                disabled = true
            }
        }
        if !disabled {
            Auth.auth().createUser(withEmail: email,
                                   password: password) { result, error in
                if error != nil {
                    alertText = error!.localizedDescription
                    showAlert = true
                } else {
                    dm.addUser(email, name, "No bio yet.", "pfp\(image)")
                }}}}}


struct Terms: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    Text("PlatterPals displays user-generated content. This includes profiles and chats sent by other users and by yourself. We take specific steps to moderate content and prevent abusive behavior.")
                    Text("There is no tolerance for objectionable content or abusive users. This includes profiles and chats with offensive content or content inappropriate for minors.")
                    Text("Users may filter objectionable content by hiding specific profiles. Users may flag objectionable content in the top right of each profile update. Users may also block abusive accounts in the chats or profile pages.")
                    Text("PlatterPals will act on objectionable content within 24 hours by removing the content and ejecting the user who provided the offending content.")
                    Text("For support and privacy policy inquiries, please visit www.platterpals.com.")
                }
            }
            .padding(20.0)
            .navigationTitle("PlatterPals EULA")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }}}}}}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
            .environmentObject(DataManager())
    }
}
