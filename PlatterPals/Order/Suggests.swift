import SwiftUI

struct Suggests: View {
    
    @State var restaurant = ""
    @State var cuisine = "Any"
    @State var friend = "Everyone"
    
    @State var friends = ["Everyone"] + userNames
    @Environment(\.dismiss) var dismiss
    @State var showLoading = false
    
    var body: some View {
        if showLoading {
            withAnimation {
                SplashOrder()
            }
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16.0) {
                
                BigButton(text: "Let us decide for you!", route: "splash")
                
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
                if friend != "Everyone" {
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
                    }}}}}}

struct Suggests_Previews: PreviewProvider {
    static var previews: some View {
        Suggests()
    }
}
