import SwiftUI

struct Sync: View {
    
    @State var email = ""
    @State var password = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16.0) {
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
                    
                    Button("Open in browser") {
                        openURL(URL(string: "https://www.doordash.com")!)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 20.0)
                    Button("Open in app") {
                        openURL(URL(string: "https://itunes.apple.com/app/id719972451")!)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(20.0)
                .navigationTitle("Log in to DoorDash")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }}}}}}}


struct Sync_Previews: PreviewProvider {
    static var previews: some View {
        Sync()
    }
}
