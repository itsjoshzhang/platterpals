import SwiftUI

// https://github.com/alfianlosari/ChatGPTSwiftUI

struct Suggest: View {
    
    @State var place = ""
    @State var food = "All"
    @State var showSplash = false
    @Environment(\.dismiss) var dismiss
    
    @State var friend = User(id: "", name: "",
                        text: "", city: "", views: 0)
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Form {
                    Section(header: Text("Got something in mind?")
                        .font(.subheadline)
                        .textCase(.none))
                    {
                        Picker("Type of cuisine", selection: $food) {
                            ForEach(foodList, id: \.self) { food in
                                Text(food)
                            }
                        }
                        TextField("Restaurant name", text: $place)
                    }
                    
                    Section(header: Text("Refer from a friend?")
                        .font(.subheadline)
                        .textCase(.none))
                    {
                        Picker("Friend's name", selection: $friend) {
                            ForEach(DM.md().favUsers, id: \.self) { id in
                                Text(DM.user(id: id).name)
                            }
                        }
                    }
                }
                if friend.id != "" {
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
                Splash(first: false)
                    .environmentObject(DM)
            }}}}

struct Order: View {
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Text("Hi!")
    }
}
