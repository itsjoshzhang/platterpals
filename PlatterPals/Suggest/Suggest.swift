import SwiftUI

struct Suggest: View {

    // ## TRACK INFO ## \\
    @State var place = ""
    @State var cuisine = "All"
    @State var friend = "None"
    @State var showOption = false
    @State var showParams = false
    @State var showChatGPT = false

    // ## AI SETTINGS ## \\
    @State var miles = 0.5
    @State var options = 1
    @State var people = 1
    @State var price = 10
    @State var style = "Casual"

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    // ## OTHER VIEWS ## \\
    
    @State var fuckery = false
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
        VStack(spacing: 1) {
        if fuckery {

        // ## ORDER INFO ## \\

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
            VStack {
                Text("\(DM.user(id: friend).name)'s favorite foods")
                    .font(.headline)
                Text("No favorites yet")
                    .foregroundColor(.secondary)
                // TODO: use aiOrders and favFoods to list favorites
        }}}
        .disabled(block2)
        .opacity(block2 ? 0.5: 1)

        // ## SEARCH INFO ## \\

        Section("Search settings") {

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

    // ## FUNCTIONS ## \\

    func orderLogic() {
        var text = ""
        if !place.isEmpty {
            text += "Search the menu of \(place). "

        } else if cuisine != "All" {
            text += "Search for \(cuisine) food. "

        } else if friend != "None" {
            let data = DM.data(id: friend).favFoods
            if !data.isEmpty {
                text += "Find food similar to \(data[0]). "
            }
        // TODO: use aiOrders and favFoods to list favorites
        } else {
            let data = DM.md().favFoods
            if !data.isEmpty {
                text += "Find food similar to \(data[0]). "
            }
        }
        if showOption {
            let n = (people == 1 ? "person": "people")
            text += "Find a \(style) place for \(people) \(n). "

            let p = (price >= 50 ? price - 10: price - 5)
            text += "Find food from $\(p) - \(price). "
        }
        text += "Search within \(miles) mi of UC Berkeley. "
        // TODO: replace city with user's coordinates

        text += "Show ONLY \(options) menu items. "

        VM.api = ChatGPTAPI(text: text)
        withAnimation {
            showChatGPT = true
        }}}
