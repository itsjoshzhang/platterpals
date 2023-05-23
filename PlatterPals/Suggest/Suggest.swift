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
    @State var location = "My Location"

    // ## BOOLEANS ## \\
    @State var fuckery = false
    @State var showOption = false
    @State var showParams = false
    @State var showChatGPT = false

    // ## OBJECTS ## \\
    @EnvironmentObject var MD: MapsData
    @EnvironmentObject var DM: DataManager
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
    // ## ORDER INFO ## \\

    var content: some View {
        NavigationStack {
        VStack(spacing: 1) {

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
        TextField("Restaurant name", text: $place)
        }
        .disabled(block1)
        .opacity(block1 ? 0.5: 1)

        // ## FRIEND INFO ## \\

        Section("Ask someone you follow?") {

        Picker("Person's name: ", selection: $friend) {
            ForEach(["None"] + DM.md().favUsers, id: \.self) { id in
                if id == "None" {
                    Text("None")
                } else {
                    Text(DM.user(id: id).name)
                }}}

        if friend == "None" {
            Text("Currently using: your past orders")
                .foregroundColor(.secondary)
                .opacity(0.5)
        } else {
            Cards(id: friend)
        }
        }
        .disabled(block2)
        .opacity(block2 ? 0.5: 1)

        // ## SEARCH INFO ## \\

        Section("Search settings") {

        Picker("", selection: $location) {
            ForEach(["My Location", "UC Berkeley"], id: \.self) {
                Text($0)
            }
        }
        .tint(.pink)
        .foregroundColor(.pink)
        .pickerStyle(.segmented)

        let s = (miles == 1 ? "": "s")
        Stepper("Range: \(miles, specifier: "%.1f") mile\(s)",
                value: $miles, in: 0.5...5.0, step: 0.5)

        let z = (options == 1 ? "": "s")
        Stepper("Show: \(options) result\(z)",
                value: $options, in: 1...5)
        }
        Section(header: Text(showOption ?
            "Clear options": "Optional items")
            .bold().underline()
            .onTapGesture {
                withAnimation {
                    showOption.toggle()
                }}){

        // ## OPTIONALS ## \\

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
        .navigationTitle("Let's Order")
        Button("Let's Order") {
            orderLogic()
        }
        .buttonStyle(.borderedProminent)
        .padding(16)

        } else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

    // ## POSITIONING ## \\

    func orderLogic() {
        var text = ""
        let c = MD.region.center
        text += "Search within \(miles) miles of "

        if location == "My Location" {
            text += "My location (coordinates \(c.latitude), \(c.longitude)). "
        } else {
            text += "UC Berkeley. "
        }
        if !place.isEmpty {
            text += "Search the menu of \(place). "

        } else if cuisine != "All" {
            text += "Search for \(cuisine) food. "

        // ## FRIEND INFO ## \\

        } else if friend != "None" {
            let favs = DM.data(id: friend).favFoods
            if !favs.isEmpty {
                text += getOrder(favs: favs) + ". "
            }
        } else {
            let favs = DM.md().favFoods
            if !favs.isEmpty {
                text += getOrder(favs: favs) + ". "
            }
        }
        // ## OPTIONALS ## \\

        if showOption {
            let n = (people == 1 ? "person": "people")
            text += "Find a \(style) place for \(people) \(n). "

            let p = (price >= 50 ? price - 10: price - 5)
            text += "Find food from $\(p) - \(price). "
        }
        text += "Show ONLY \(options) menu items / restaurants. "

        VM.api = ChatGPTAPI(text: text)
        withAnimation {
            showChatGPT = true
        }
    }
    // ## GET ORDERS ## //

    @State var orders = [AIOrder]()

    func getOrder(favs: [String]) -> String {
        FS.collection("aiOrders").addSnapshotListener { snap,_ in
        if let snap = snap {

        orders = snap.documents.compactMap { doc -> AIOrder? in
        if let ord = try? doc.data(as: AIOrder.self) {
            return ord
        }
        return nil
        }}}

        // MARK: - I give up. TODO: - FIXME later.

        var text = "Find food similar to "
        for ord in orders {
            if favs.contains(ord.id) {
                text += ord.order + " from " + ord.place + ", and "
            }
        }
        return text.trimmingCharacters(in:
            CharacterSet(charactersIn: ", and "))
    }
}
