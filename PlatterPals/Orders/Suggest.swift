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

        Section("Ask someone you know?") {

        Picker("Name of friend", selection: $friend) {
            ForEach(friends(), id: \.self) { id in
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
                Text("\(DM.user(id: friend).name)'s favorite foods:")
                    .font(.headline)
                Text("No favorites yet.")
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
        // ## AI SETTINGS ## \\

        Section(header: Text("AI Parameters")
            .underline()
            .onTapGesture {
                withAnimation {
                    showParams.toggle()
                }}){

        if showParams {
            VStack {
            HStack {
                Text("Formal")
                Spacer()
                Text("Personality")
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
        .navigationTitle("Let's Order")

        Button("Let's Order") {
            orderLogic()
        }
        .padding(.bottom, 16)
        .buttonStyle(.borderedProminent)

        // I don't know wtf this does.
        } else {
            Back()
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

    // ## FUNCTIONS ## \\

    func friends() -> [String] {
        var data = ["None"] + DM.md().favUsers

        for id in DM.md().chatting {
            if !data.contains(id) {
                data.append(id)
            }
        }
        return data
    }

    func orderLogic() {
        var text = "You are PlatterPal, an AI that finds nearby food and restaurants. "

        if !place.isEmpty {
            text += "Search the menu of \(place). If not found, "

        } else if cuisine != "All" {
            text += "Search for \(cuisine) food in particular. "

        } else if friend != "None" {
            let data = DM.data(id: friend).favFoods
            if !data.isEmpty {
                text += "Suggest food that's similar to \(data[0]). "
            }
        // TODO: use aiOrders and favFoods to list favorites
        } else {
            let data = DM.md().favFoods
            if !data.isEmpty {
                text += "Suggest food that's similar to \(data[0]). "
            }
        }
        text += "Search within \(miles) miles of UC Berkeley. Show only \(options) option."

        var model = model
        switch model {
            case "gpt-3": model = "text-davinci-003"
            case "gpt-3.5": model = "gpt-3.5-turbo"
            default: model = "gpt-3.5-turbo"
        }
        VM.api.editSets(model: model, text: text, temp: temp)
        withAnimation {
            showChatAI = true
        }
    }
}
