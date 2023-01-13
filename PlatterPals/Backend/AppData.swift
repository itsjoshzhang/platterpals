import SwiftUI

var cuisines = ["Any", "American", "Brazilian", "Caribbean", "Chinese", "Ethiopian", "French", "German", "Indian", "Italian", "Japanese", "Korean", "Mexican", "Middle Eastern", "Russian", "South American", "Thai", "Vietnamese"]

var userNames = ["Josh Z", "Saira G", "Albert Y", "Saathvik S"]
var userImages = ["pfp1", "pfp2", "pfp3", "pfp4", "logo"]

struct MyTabView: View {
    
    @State var tag = 2
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        TabView(selection: $tag) {
            Chats()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }.tag(1)
            Feed()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(2)
            Profile()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }.tag(3)
        }
        .environmentObject(dm)
    }
}
extension ChatsItem {
    static let data = [
        ChatsItem(caption: "Active now", user: "Josh Z"),
        ChatsItem(caption: "Active 1 min ago", user: "Saira G"),
        ChatsItem(caption: "Active 3 min ago", user: "Albert Y"),
        ChatsItem(caption: "Active 13 min ago", user: "Saathvik S"),
    ]
}
struct ChatsItem: Identifiable, Hashable {
    let id = UUID()
    let caption: String
    let user: String
}
extension Chats {
    func deleteItems(atOffsets offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}
struct Carousel: View {
    @State var tag: String
    
    var body: some View {
        TabView(selection: $tag) {
            Card(headline: "Carnitas Tacos - Tacos Sinaloa",
                 caption: "My pregnant wife thought the limes were fantastic.",
                 image: "tacos")
            .tag("Josh Z")
            Card(headline: "The Beef Lasagna - Pasta Bene",
                 caption: "I make my boyfriend get me this stuff all the time.",
                 image: "lasagna")
            .tag("Saira G")
            Card(headline: "Salmon Carpaccio - Gypsy's Trattoria",
                 caption: "Tasted just like how I imagined a blahaj would taste.",
                 image: "salmon")
            .tag("Albert Y")
            Card(headline: "Polish Gnocchi - Little Italy SF",
                 caption: "Learned it's not pronounced ganochee. Thanks Saira.",
                 image: "gnocchi")
            .tag("Saathvik S")
        }
        .padding(.horizontal, 20.0)
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 160.0)
    }
}
extension SettingsItem {
    static let data = [
        SettingsItem(headline: "Chat", caption: "Blocked users, notifications", imageName: "message"),
        SettingsItem(headline: "Feed", caption: "Suggested posts, swipe history", imageName: "house"),
        SettingsItem(headline: "Profile", caption: "Profile publicity, picture, bio", imageName: "person.crop.circle"),
        SettingsItem(headline: "Privacy", caption: "Post visibility, chat requests", imageName: "lock"),
        SettingsItem(headline: "Security", caption: "Login info, payment methods", imageName: "shield"),
        SettingsItem(headline: "Account", caption: "Link to DoorDash, deletion", imageName: "moon"),
    ]
}
extension Carousel {
    struct Card: View {
        
        let headline: String
        let caption: String
        let image: String
        
        var body: some View {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                VStack(alignment: .leading, spacing: 8.0) {
                    HStack(spacing: 16.0) {
                        
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                        Text(headline)
                            .font(.headline)
                    }
                    Text(caption)
                }
                .padding(16.0)
                Color(.secondarySystemFill)
                    .cornerRadius(10.0)
            }
        }
    }
}
struct CarouselItem: Identifiable {
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
struct SettingsItem: Identifiable, Hashable {
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
