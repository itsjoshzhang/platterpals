// File: checked

import SwiftUI

struct User: Identifiable, Hashable {
    var id: String
    var name: String
    var image: String
    var city: String
}

struct UserData: Identifiable {
    var id: String
    var favorites: [String]
    var following: [String]
    var chatting: [String]
    var blocked: [String]
}

struct Profile: Identifiable {
    var id: String
    var name: String
    var image: String
    var text: String
    var likes: Int
}

struct Message: Identifiable {
    var id: String
    var text: String
    var sender: String
    var getter: String
    var time: Date
}

struct AIOrder: Identifiable {
    var id: String
    var order: String
    var location: String
    var rating: Int
    var time: Date
}

struct Setting: Identifiable {
    var id: String = ""
    var notifs = true
    var emails = true
    var privacy = true
    var location = true
}

struct Div: View {
    var body: some View {
        Divider()
            .frame(minHeight: 3)
            .overlay(.pink)
    }
}

struct ChatsItem: Identifiable, Hashable {
    let id = UUID()
    let caption: String
    let user: String
}

extension SettingsItem {
    static let data = [
        SettingsItem(headline: "Chats", caption: "Blocked users, notifications", imageName: "message"),
        SettingsItem(headline: "Feed", caption: "Swipe history, profile suggests", imageName: "house"),
        SettingsItem(headline: "Profile", caption: "Profile picture, bio, publicity", imageName: "person"),
        SettingsItem(headline: "Security", caption: "Payment methods, login info", imageName: "lock"),
        SettingsItem(headline: "Account", caption: "Link to DoorDash, deletion", imageName: "key"),
    ]
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let headline: String
    let caption: String
    let imageName: String
}
