// File: checked

import SwiftUI

struct Guide: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        TabView {
            GuideView(image: 1, title: "Welcome to PlatterPals!",
                      text: "Get local food suggestions from an intelligent AI and find friends who have similar taste buds.")
            
            GuideView(image: 2, title: "Can't decide what to eat?",
                      text: "Let your assistant choose for you. Just fill in your favorite foods and follow some friends!")
            
            GuideView(image: 3, title: "Go find your Platter Pal!",
                      text: "We've made it easy to match with the users you like. Swipe left to remove and right to approve!")
        }
        .environmentObject(DM)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct GuideView: View {
    
    var image: Int
    var title: String
    var text: String
    @State var showFeed = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        VStack(spacing: 16) {
            
            Image("guide\(image)")
                .resizable()
                .scaledToFit()
                .foregroundColor(.pink)
            
            Text(title)
                .font(.title).bold()
                .foregroundColor(.pink)
            
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if image == 3 {
                Button("Get started") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
    }
}

struct Terms: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("PlatterPals displays user-generated content. This includes other users and you. We take specific steps to moderate content and prevent abusive behavior.")
                    
                    Text("There's no tolerance for objectionable content or abusive users. This includes profiles and chats that have offensive content or are unsuitable for minors.")
                    
                    Text("Users may filter such content and hide specific profiles, flag it in the top right of each profile, and block abusive accounts in the chats or profile pages.")
                    
                    Text("PlatterPals will act on such content within 24 hours by removing it and banning the flagged user. For support or inquiries, visit www.platterpals.com.")
                }
            }
            .padding(20)
            .navigationTitle("PlatterPals Terms")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Guide_Previews: PreviewProvider {
    static var previews: some View {
        Guide()
            .environmentObject(DataManager())
    }
}
