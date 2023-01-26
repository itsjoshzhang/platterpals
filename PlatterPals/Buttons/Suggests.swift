import SwiftUI

struct Suggests: View {
    
    @State var restaurant = ""
    @State var cuisine = "Any"
    @State var friend = "All"
    @State var showLoading = false
    
    var friends = ["All", "Josh Z", "Saira G", "Albert Y", "Roma N"]
    var cuisines = ["Any", "American", "Brazilian", "Caribbean", "Chinese", "Ethiopian", "French", "German", "Indian", "Italian", "Japanese", "Korean", "Mexican", "Middle Eastern", "Russian", "South American", "Thai", "Vietnamese"]
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16.0) {
                
                BigButton(text: "Let us decide for you!", route: "splash")
                    .environmentObject(dm)
                
                Text("Adjust settings below")
                    .font(.headline)
                    .padding(.horizontal, 20.0)
                Form {
                    Section(header:
                                Text("Got something in mind?")
                        .font(.subheadline)
                        .textCase(.none)){
                            
                            Picker("Type of cuisine", selection: $cuisine) {
                                ForEach(cuisines, id: \.self) {
                                    Text($0)
                                }
                            }
                            TextField("Restaurant name", text: $restaurant)
                        }
                    Section(header:
                                Text("Wanna refer to a friend?")
                        .font(.subheadline)
                        .textCase(.none)){
                            
                            Picker("Friend's name", selection: $friend) {
                                ForEach(friends, id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                }
                if friend != "All" {
                    Text("\(friend)'s favorite foods:")
                        .font(.headline)
                    Carousel(tag: friend)
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
            .fullScreenCover(isPresented: $showLoading) {
                Splash2()
                    .environmentObject(dm)
            }
        }
    }
}
struct Suggests_Previews: PreviewProvider {
    static var previews: some View {
        Suggests()
            .environmentObject(DataManager())
    }
}
