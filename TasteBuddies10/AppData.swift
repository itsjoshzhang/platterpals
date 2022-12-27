import SwiftUI

extension ChatsItem {
    
    static let data = [
        ChatsItem(headline: "Josh Z.", caption: "Active now", imageName: "Josh"),
        ChatsItem(headline: "Saira G.", caption: "Active 1 min ago", imageName: "Saira"),
        ChatsItem(headline: "Albert Y.", caption: "Active 3 min ago", imageName: "Albert"),
        ChatsItem(headline: "Saathvik S.", caption: "Active 13 min ago", imageName: "Saathvik"),
    ]
}
extension CarouselItem {
    
    static let data = [
        CarouselItem(headline: "Carnitas Tacos - Tacos Sinaloa",
                     caption: "My pregnant wife thought the limes were fantastic.",
                     imageName: "tacos"),
        CarouselItem(headline: "Salmon Carpaccio - Gypsy's Trattoria",
                     caption: "Tasted just like how I imagined a blahaj would taste.",
                     imageName: "salmon"),
        CarouselItem(headline: "Polish Gnocchi",
                     caption: "Learned it's not pronounced ganochee. Thanks Saira.",
                     imageName: "gnocchi"),
    ]
}
extension MyGridItem {
    
    static let data = [
        MyGridItem(imageName: "tacos"),
        MyGridItem(imageName: "lasagna"),
        MyGridItem(imageName: "salmon"),
        MyGridItem(imageName: "gnocchi"),
        MyGridItem(imageName: "tacos"),
        MyGridItem(imageName: "lasagna"),
        MyGridItem(imageName: "salmon"),
        MyGridItem(imageName: "gnocchi"),
        MyGridItem(imageName: "tacos")
    ]
}
extension SettingsItem {
    
    static let data = [
        SettingsItem(headline: "Chat", caption: "Blocked users, notifications", imageName: "message"),
        SettingsItem(headline: "Feed", caption: "Suggested posts, swipe history", imageName: "house"),
        SettingsItem(headline: "Profile", caption: "Profile publicity, image, bio", imageName: "person.crop.circle"),
        SettingsItem(headline: "Privacy", caption: "Post visibility, chat requests", imageName: "lock"),
        SettingsItem(headline: "Security", caption: "Login info, payment methods", imageName: "shield"),
        SettingsItem(headline: "Account", caption: "Link to DoorDash, deletion", imageName: "moon"),
    ]
}


struct Carousel: View {
    @State var items = CarouselItem.data
    
    var body: some View {
        TabView {
            ForEach(items) { item in
                Card(headline: item.headline, caption: item.caption, image: Image(item.imageName))
                    .padding(.horizontal, 20.0)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 160.0)
    }
}
extension Carousel {
    struct Card: View {
        
        let headline: String
        let caption: String
        let image: Image
        
        var body: some View {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                VStack(alignment: .leading, spacing: 8.0) {
                    HStack(spacing: 16.0) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
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
struct Grid: View {
    @State var items = MyGridItem.data
    
    private let columns = Array(
        repeating: GridItem(.flexible(maximum: maxWidth), spacing: hSpacing),
        count: columns)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Self.vSpacing) {
            ForEach(items) { item in
                Cell(image: Image(item.imageName))
            }
        }
    }
}
private extension Grid {
    
    static let hSpacing: CGFloat = 1.0
    static let vSpacing: CGFloat = 1.0
    static let columns = 3

    static var maxWidth: CGFloat {
        let spacing: CGFloat = CGFloat(columns - 1) * hSpacing
        return (UIScreen.main.bounds.width - spacing) / CGFloat(columns)
    }
}
extension Grid {
    
    struct Cell: View {
        let image: Image
        
        var body: some View {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                VStack(alignment: .center, spacing: 8.0) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                }}}}}


struct ChatsItem: Identifiable, Hashable {
    
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
struct CarouselItem: Identifiable {
    
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
struct MyGridItem: Identifiable {
    
    let id = UUID()
    let imageName: String
}
struct SettingsItem: Identifiable, Hashable {
    
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
