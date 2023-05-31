import SwiftUI
import FirebaseFirestoreSwift

struct Suggest: View {

    // ## NUMBERS ## \\
    @State var miles = 0.5
    @State var options = 1
    @State var people = 1
    @State var price = 10

    // ## STRINGS ## \\
    @State var place = ""
    @State var cuisine = "All"
    @State var friend = "None"
    @State var style = "Casual"
    @State var location = ""

    // ## BOOLEANS ## \\
    @State var fuckery = false
    @State var showCustom = false
    @State var showOption = false
    @State var showChatGPT = false

    // ## OBJECTS ## \\
    @EnvironmentObject var DM: DataManager
    @StateObject var OM = OrderManager()
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    // ## OTHER VIEWS ## \\
    var body: some View {
        if showChatGPT {
            ChatGPT()
                .environmentObject(DM)
                .environmentObject(VM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
        VStack {

        // ## ORDER INFO ## \\

        if fuckery {
        Form {
            let block1 = !(friend == "None")
            let block2 = !(place.isEmpty && cuisine == "All")

        Section("Got something in mind?") {

        Picker("Type of cuisine", selection: $cuisine) {
            ForEach(foodList, id: \.self) { food in
                Text(food)
            }
        }
        VStack {
            TextField("Restaurant name", text: $place)
                .submitLabel(.done)
            Max(count: 32, text: $place)
        }
        }
        .disabled(block1)
        .opacity(block1 ? 0.5: 1)

        // ## FRIEND INFO ## \\

        Section("Ask someone you follow?") {

        Picker("User's name: ", selection: $friend) {
            ForEach(["None"] + DM.md().favUsers, id: \.self) { id in
                Text(id == "None" ? id: DM.user(id: id).name)
            }
        }
        if friend == "None" {
            Text("Currently using: Your favorites")
                .foregroundColor(block2 ? .secondary: .pink)
                .onAppear {
                    OM.getOrders(id: DM.my().id)
                }
        } else {
            Cards(id: friend)
                .environmentObject(DM)
                .environmentObject(OM)
            }
        }
        .disabled(block2)
        .opacity(block2 ? 0.5: 1)

        // ## SEARCH INFO ## \\

        Section("Search settings") {

        if showCustom {
            TextField("Enter a location", text: $location)
                .submitLabel(.done)
                .onAppear {
                    location = ""
                }
        } else {
            Picker("", selection: $location) {
                ForEach([DM.my().city, "Custom Location"], id: \.self) {
                    Text($0)
                }
            }
            // ## SEARCH INFO ## \\

            .pickerStyle(.segmented)
            .onChange(of: location) {_ in
                if location == "Custom Location" {
                    showCustom = true
                }}}

        let s = (miles == 1 ? "": "s")
        Stepper("Range: \(miles, specifier: "%.1f") mile\(s)",
                value: $miles, in: 0.5...5.0, step: 0.5)

        let z = (options == 1 ? "": "s")
        Stepper("Show: \(options) result\(z)",
                value: $options, in: 1...5)
        }
        // ## OPTIONALS ## \\

        Section(header: Text(showOption ? "Clear options":
            "Optional items")
            .bold().underline()
            .onTapGesture {
                withAnimation {
                    showOption.toggle()
                }}){

        if showOption {
        Stepper("Number of people: \(people)",
                value: $people, in: 1...10)

        let p = (price >= 50 ? price - 10: price - 5)
        Stepper("Price range: $\(p)-\(price)",
                value: $price, in: 10...100, step: 10)

        Picker("", selection: $style) {
            ForEach(["Quick snack", "Casual", "Formal"], id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        }}}

        // ## MODIFIERS ## \\

        .onAppear {
            location = DM.my().city
        }
        .navigationTitle("Let's Order")
        Button("Let's Order") {
            orderLogic()
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 8)

        } else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

    // ## FOOD LOGIC ## \\

    func orderLogic() {
        var text = ""

        if !place.isEmpty {
            text += "Search the menu of \(place). "
        } else if cuisine != "All" {
            text += "Search for \(cuisine) food. "

        } else if friend != "None" {
            text += addFavs(id: friend)
        } else {
            text += addFavs(id: DM.my().id)
        }
        // ## OPTIONALS ## \\

        if showOption {
            let n = (people == 1 ? "person": "people")
            text += "Find a \(style) place for \(people) \(n). "

            let p = (price >= 50 ? price - 10: price - 5)
            text += "Find food from $\(p)-\(price). "
        }
        if location.contains("erkeley") {
            location = "UC Berkeley, CA"
        }
        // ## PARAMETERS ## \\

        text += "Search within \(miles) miles of \(location). "
        text += "Show only \(options) menu item / restaurant. "

        VM.api = ChatGPTAPI(text: text)
        withAnimation {
            showChatGPT = true
        }
    }
    // ## TEXT LOGIC ## //

    func addFavs(id: String) -> String {
        let ans = "Find food similar to"
        let favs = DM.data(id: id).favFoods

        if !favs.isEmpty {
            let rand = favs.shuffled().first
            for ord in OM.orders {
                if ord.id == rand {
                    return "\(ans) \(ord.order) from \(ord.place). "
        }}}
        return "Surprise me with a dish / restaurant nearby. "
    }
}
