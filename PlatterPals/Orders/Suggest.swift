import SwiftUI

struct Suggest: View {

    // ## TRACK INFO ## \\
    @State var place = ""
    @State var cuisine = "All"
    @State var friend = "None"
    @State var showChatAI = false
    @State var showParams = false

    // ## AI SETTINGS ## \\
    @State var miles = 0.5
    @State var options = 1
    @State var temp = 0.5
    @State var model = "GPT 3.5"
    @State var models = ["GPT 3", "GPT 3.5", "GPT 4"]

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    // ## OTHER VIEWS ## \\
    
    @State var fuckery = false
    var body: some View {
        if showChatAI {
            ChatGPT()
                .environmentObject(DM)
                .environmentObject(VM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
        VStack(spacing: 16) {
        if fuckery {

        // ## FOOD INFO ## \\

        Form {
            let block1 = !(friend == "None")
            let block2 = !(place == "" && cuisine == "All")

        Section("Got something in mind?") {

        Picker("Type of cuisine", selection: $cuisine) {
            ForEach(foodList, id: \.self) { id in
                Text(id)
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
            Text("Currently using: Your order history")
                .foregroundColor(.secondary)
        } else {
            VStack {
                Text("\(DM.user(id: friend).name)'s favorite foods: ")
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
        Stepper("Search within: \(miles, specifier: "%.1f") mile\(s)",
                value: $miles, in: 0.5...5.0, step: 0.5)

        let z = (options == 1 ? "": "s")
        Stepper("Show: \(options) search result\(z)",
                value: $options, in: 1...5)
        }
        Section(header: Text("AI settings")
            .underline()
            .onTapGesture {
                withAnimation {
                    showParams.toggle()
                }}){

        // ## AI SETTINGS ## \\

        if showParams {
            VStack {
            HStack {
                Text("Formal")
                Spacer()
                Text("Personality")
                    .font(.none)
                    .foregroundColor(.black)
                Spacer()
                Text("Casual")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            Slider(value: $temp, in: 0.0...1.0, step: 0.25)
            }
            VStack {
                Text("GPT Version")
                Picker("", selection: $model) {
                    ForEach(models, id: \.self) { id in
                        Text(id)
                    }
                }
                .pickerStyle(.segmented)
        }}}}

        // ## MODIFIERS ## \\

        .navigationTitle("Let's Order")
        Button("Let's Order") {
            orderLogic()
        }
        .padding(.bottom, 16)
        .buttonStyle(.borderedProminent)

        } else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

    // ## FUNCTIONS ## \\

    func orderLogic() {
        var text = "You're PlatterPal, an AI that finds food and restaurants. "

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
        text += "Search within \(miles) mi of UC Berkeley. "
        // TODO: replace city with user's coordinates

        text += "Show ONLY the best \(options) menu items. "

        switch model {
            case "gpt-3": model = "text-davinci-003"
            case "gpt-3.5": model = "gpt-3.5-turbo"
            default: model = "gpt-3.5-turbo"
        }
        VM.api = ChatGPTAPI(model: model, text: text, temp: temp)
        withAnimation {
            showChatAI = true
        }
    }
}
