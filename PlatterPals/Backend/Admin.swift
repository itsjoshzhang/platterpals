import SwiftUI

struct Admin: View {
    
    @State var email = ""
    @State var name = ""
    @State var city = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            List {
                Text("This user")
                HStack(spacing: 16) {
                    
                    Image(DM.thisUser.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    
                    Text(DM.thisUser.name)
                    Spacer()
                    
                    Text(DM.thisUser.id)
                        .font(.caption2)
                }
                Text("All users")
                
                ForEach(DM.userArray) { user in
                    HStack(spacing: 16) {
                        
                        Image(user.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                        Text(user.name)
                        Spacer()

                        Text(user.id)
                            .font(.caption2)
                    }
                }
            }
            Form {
                TextField("Email", text: $email)
                TextField("Name", text: $name)
                
                Picker("City", selection: $city) {
                    ForEach(DM.cities, id: \.self) { city in
                        Text(city)
                    }
                }
                Button("Add user") {
                    DM.addUser(id: email, name: name, image: "logo", city: city)
                }
            }
            .navigationTitle("Admin")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }}}}}}

struct Sync: View {
    
    @State var email = ""
    @State var password = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Image("doordash")
                        .resizable()
                        .scaledToFit()
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.pink)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Divider()
                        .frame(height: 3)
                        .overlay(.pink)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.pink)
                    
                    Divider()
                        .frame(height: 3)
                        .overlay(.pink)
                    
                    Button("Open in browser") {
                        openURL(URL(string: "https://www.doordash.com")!)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 20)
                    
                    Button("Open in app") {
                        openURL(URL(string: "https://itunes.apple.com/app/id719972451")!)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(20)
                .navigationTitle("Log in to DoorDash")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }}}}}}}


struct Admin_Previews: PreviewProvider {
    static var previews: some View {
        Admin()
            .environmentObject(DataManager())
        Sync()
            .environmentObject(DataManager())
    }
}
