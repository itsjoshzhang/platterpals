// File: checked

import SwiftUI

struct User: Identifiable, Hashable {
    let id: String
    let name: String
    let image: String
    let city: String
}

struct UserData: Identifiable {
    let id: String
    var favorites: [String]
    let following: [String]
    let chatting: [String]
    let blocked: [String]
}

struct Profile: Identifiable {
    let id: String
    let image: String
    let city: String
    let text: String
    let likes: Int
}

struct Message: Identifiable {
    let id: String
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder: Identifiable {
    let id: String
    let order: String
    let location: String
    let rating: Int
    let time: Date
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
