import SwiftUI

struct Sync: View {
    
    @State var email = ""
    @State var password = ""
    @State var loggedIn = false
    @EnvironmentObject var dm: DataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                Image("doordash")
                    .resizable()
                    .scaledToFit()
                
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
                Button("Log in") {
                    //loginAuthentication()
                }
                .disabled(true)
                .buttonStyle(.borderedProminent)
                .padding(20.0)
                
                Text("App in beta: DoorDash API coming soon")
                    .foregroundColor(.secondary)
            }
            .padding(20.0)
            .navigationTitle("Log in to DoorDash")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Sync_Previews: PreviewProvider {
    static var previews: some View {
        Sync()
            .environmentObject(DataManager())
    }
}
