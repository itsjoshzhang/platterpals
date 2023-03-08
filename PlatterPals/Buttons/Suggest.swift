// File: checked
// TODO: everything about food suggesting

import SwiftUI

struct Suggest: View {
    
    @State var location = ""
    @State var cuisine = "All"
    @State var showSplash = false
    @Environment(\.dismiss) var dismiss
    
    @State var friend = User(id: "", name:
               "All", image: "", city: "")
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                BigButton(path: 1, text: "Let us decide for you!")
                    .environmentObject(DM)
                
                Form {
                    Section(header: Text("Got something in mind?")
                        .font(.subheadline)
                        .textCase(.none))
                    {
                        Picker("Type of cuisine", selection: $cuisine) {
                            ForEach(DM.foodList, id: \.self) {
                                Text($0)
                            }
                        }
                        TextField("Restaurant name", text: $location)
                    }
                    
                    Section(header: Text("Refer from a friend?")
                        .font(.subheadline)
                        .textCase(.none))
                    {
                        Picker("Friend's name", selection: $friend) {
                            ForEach(DM.userList) { user in
                                Text(user.name)
                            }
                        }
                    }
                }
                if friend.name != "All" {
                    Text("\(friend.name)'s favorite foods:")
                        .font(.headline)
                }
            }
            .navigationTitle("Let's Order!")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showSplash) {
                Splash2()
                    .environmentObject(DM)
            }
        }
    }
}
struct Suggest_Previews: PreviewProvider {
    static var previews: some View {
        Suggest()
            .environmentObject(DataManager())
    }
}
