import SwiftUI

struct Suggests: View {
    
    var cuisines = ["Any", "American", "Brazilian", "Caribbean", "Chinese", "Ethiopian", "French", "German", "Indian", "Italian", "Japanese", "Korean", "Mexican", "Middle Eastern", "Russian", "South American", "Thai", "Vietnamese"]
    
    var friends = ["Everyone", "Saira", "Josh", "Albert", "Saathvik"]
    
    @State private var restaurant = ""
    @State private var cuisine = "Any"
    @State private var friend = "Everyone"
    
    @FocusState private var focus: Bool
    @State private var showLoading = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16.0) {
                
                BigButton(text: "Let us decide for you!", route: "loading")
                
                Text("Adjust settings below")
                    .font(.headline)
                    .padding(.horizontal, 20.0)
                Form {
                    Section(header:
                        Text("Got something in mind?").font(.headline)){
                        
                        Picker("Type of cuisine", selection: $cuisine) {
                            ForEach(cuisines, id: \.self) {
                                Text($0)
                            }
                        }
                        TextField("Restaurant name", text: $restaurant)
                            .focused($focus)
                    }
                    Section(header:
                                Text("Wanna refer to a friend?").font(.headline)){
                        
                        Picker("Friend's name", selection: $friend) {
                            ForEach(friends, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                if friend != "Everyone" {
                    Text("\(friend)'s top 3 favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    Carousel()
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
                SplashOrder()
            }
        }
    }
}
struct Suggests_Previews: PreviewProvider {
    static var previews: some View {
        Suggests()
    }
}
