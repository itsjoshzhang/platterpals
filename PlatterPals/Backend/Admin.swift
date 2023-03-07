// File: checked

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
                    
                    Image(uiImage: DM.getImage(
                        id: DM.user().id, path: "avatars"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                    
                    Text(DM.user().name)
                    Spacer()
                    Text(DM.user().id)
                        .font(.caption2)
                }
                Text("All users")
                
                ForEach(DM.userList) { user in
                    HStack(spacing: 16) {
                        
                        Image(uiImage: DM.getImage(
                            id: user.id, path: "avatars"))
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
                    ForEach(DM.cityList, id: \.self) { city in
                        Text(city)
                    }
                }
                Button("Add user") {
                    DM.makeUser(id: email, name: name, city: city)
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
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Image("sync")
                    .resizable()
                    .scaledToFit()
                
                TextField("Email", text: $email)
                    .foregroundColor(.pink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Div()
                
                SecureField("Password", text: $password)
                    .foregroundColor(.pink)
                Div()
                
                Button("Open in browser") {
                    openURL(URL(string: "https://www.doordash.com")!)
                }
                .buttonStyle(.bordered)
                .padding(.top, 20)
                
                Button("Open in app") {
                    openURL(URL(string:
                        "https://itunes.apple.com/app/id719972451")!)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
            .navigationTitle("Log in to DoorDash")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Admin_Previews: PreviewProvider {
    static var previews: some View {
        Admin()
            .environmentObject(DataManager())
        Sync()
            .environmentObject(DataManager())
    }
}
