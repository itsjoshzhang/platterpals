import SwiftUI

struct Guide: View {
    var body: some View {
        TabView {
            Guide2(image: 1, title: "Welcome to PlatterPals!",
            text: "Find food and restaurants in your area using an intelligent AI. Make friends with similar palates and meet your culinary soulmate!")

            Guide2(image: 2, title: "Can't decide what to eat?",
            text: "Let your GPT-powered AI assistant generate the perfect order. Just fill in your favorite cuisines and follow some foodies near you!")

            Guide2(image: 3, title: "Go find your PlatterPal!",
            text: "We've made it easy to match with people who meet your tastes. Simply swipe left on a profile to remove and swipe right to approve!")
        }
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
struct Guide2: View {
    
    var image: Int
    var title: String
    var text: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {

            if image == 3 {
                Text("").padding(10)
            }
            Image("guide\(image)")
                .resizable()
                .scaledToFit()
            
            Text(title)
                .foregroundColor(.pink)
                .font(.title).bold()
            
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if image == 3 {
                Button("Get Started") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }}.padding(16)}}

struct Terms: View {
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Text("PlatterPals displays user-generated content. This includes other users and yourself. We take specific steps to moderate content and prevent abusive behavior.")

        Text("There is no tolerance for objectionable content or abusive users. This includes profiles and chats that have offensive content or are unsuitable for viewing.")

        Text("Users may filter such content and hide specific profiles, flag users on any of their pages / posts, and block abusive accounts in the profile and chat pages.")

        Text("PlatterPals will act on such content within 24 hours by removing it and banning the flagged user. For support or inquiries, please visit www.platterpals.com.")
        Spacer()
        }
        .padding(16)
        .navigationTitle("Terms and EULA")
        .foregroundColor(.secondary)
        .background {
            Back()
        }}}}


// ## CITIES MENU ## \\
struct Cities: View {

    var addAll: Bool
    @Binding var city: String
    @State var page = 0

    var body: some View {
        VStack {
            let all = addAll ? ["All"]: []

        if page == 0 {
            Picker("", selection: $city) {
                ForEach(all + cityList, id: \.self) {
                    Text($0)

        }}} else if page == 1 {
            Picker("", selection: $city) {
                ForEach(all + allCities, id: \.self) {
                    Text($0)

        }}} else {
            TextField("Enter a city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)

            Max(count: 32, text: $city)
        }
        }
        .frame(maxWidth: UIwidth, alignment: .leading)
        .onChange(of: city) {_ in

            if city == "More..." {
                page += 1
                if page == 1 {
                    city = addAll ? "All": "Berkeley"
                } else {
                    city = ""
                }}}}}
