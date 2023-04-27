import SwiftUI

struct Suggest: View {

    @State var place = ""
    @State var cuisine = "All"
    @State var friend = "None"
    @State var showChatAI = false
    @State var showParams = false

    @State var miles = 0.5
    @State var options = 1
    @State var temp = 0.5
    @State var model = "GPT 3.5"
    @State var models = ["GPT 3", "GPT 3.5", "GPT 4"]

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

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
        Form {
        Section("Got something in mind?") {

        Picker("Type of cuisine", selection: $cuisine) {
            ForEach(foodList, id: \.self) { id in
                Text(id)
            }
        }
        TextField("Restaurant name", text: $place)
        }
        Section("Refer from a friend?") {

        Picker("Friend's name", selection: $friend) {
            let md = DM.md().favUsers + DM.md().chatting

            ForEach(["None"] + md, id: \.self) { id in
                if id == "None" {
                    Text("None")
                } else {
                    Text(DM.user(id: id).name)
                }}}

        if friend != "None" {
            VStack {
                Text("\(DM.user(id: friend).name)'s favorite foods:")
                    .font(.headline)
                Text("No favorites yet.")
                    .foregroundColor(.secondary)
            }
        } else {
            Text("Currently using: Your order history")
                .foregroundColor(.secondary)
        }
        }
        Section("Search settings") {

        Stepper("Search within: \(miles, specifier: "%.1f") miles",
                value: $miles, in: 0.5...5.0, step: 0.5)

        Stepper("Show: \(options) search result\(options == 1 ? "": "s")",
            value: $options, in: 1...5)
        }
        Section(header: Text("AI Parameters")
            .underline()
            .onTapGesture {
                withAnimation {
                    showParams.toggle()
                }
            }){
        if showParams {
            VStack {
            HStack {
                Text("Formal")
                    .font(.subheadline)
                Spacer()
                Text("Personality")
                    .foregroundColor(.black)
                Spacer()
                Text("Casual")
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)

            Slider(value: $temp, in: 0.0...1.0, step: 0.25)
            }
            VStack {
                Text("GPT Version")
                Picker("", selection: $model) {
                    ForEach(models, id: \.self) { id in
                        Text("\(id)")
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
        Text("")
        .onAppear {
        withAnimation {
            fuckery = true
        }}}}}}

    // ## FUNCTIONS ## \\

    func orderLogic() {
        // MARK: permanent
        var text = "You are PlatterPal, an AI that finds nearby food and restaurants. "

        if !place.isEmpty {
            text += "Search the menu of \(place). If not found, "
        } else if cuisine != "All" {
            text += "Search for \(cuisine) food specifically. "
        }
        // MARK: permanent
        text += "Search within \(miles) miles of UC Berkeley. "

        if friend != "None" {
            let data = DM.data(id: friend).favFoods
            if !data.isEmpty {
                text += "Suggest food that is similar to \(data[0]) "
            }
        } else {
            let data = DM.md().favFoods
            if !data.isEmpty {
                text += "Suggest food that is similar to \(data) "
            }
        }
        // MARK: permanent
        text += "Show only \(options) options."

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
