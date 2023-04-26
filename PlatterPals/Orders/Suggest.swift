import SwiftUI

struct Suggest: View {

    @State var place = ""
    @State var friend = "None"
    @State var cuisine = "All"
    @State var showChatAI = false
    @State var showParams = false

    @State var miles = 0.5
    @State var options = 1
    @State var temp = 0.5
    @State var model = "GPT 3.5"
    @State var models = ["GPT 3", "GPT 3.5", "GPT 4"]

    // TODO: fix these model names

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {
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
        Stepper("Show \(options) options",
                value: $options, in: 1...5)
        if !showParams {
            Button("AI Parameters") {
                withAnimation {
                    showParams = true
                }
            }
            .foregroundColor(.secondary)
            .frame(width: UIwidth, alignment: .center)
        }
        }
        Section("AI Parameters") {
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
            }
        }
        }
        }
        Button("Let's Order") {
            var text = "You are PlatterPal, an AI that finds nearby food and restaurants. "

            if cuisine != "All" {
                text = "Search for \(cuisine) food specifically. "
            }
            if place != "" {
                text = "Search the menu of \(place). If not found, "
            }
            text += "Search within \(miles) miles of UC Berkeley. "

            if friend != "None" {
                let data = DM.data(id: friend).favFoods
                if data.count > 0 {
                    text += "Suggest food that is similar to \(data[0]) "
                }
            } else {
                let data = DM.md().favFoods
                if data.count > 0 {
                    text += "Suggest food that is similar to \(data) "
                }
            }
            var model = model
            switch model {
                case "gpt-3": model = "text-davinci-003"
                case "gpt-3.5": model = "gpt-3.5-turbo"
                default: model = "gpt-3.5-turbo"
            }
            VM.api.editSets(model: model, text: text, temp: temp)
            showChatAI = true
        }
        .padding(.bottom, 16)
        .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Let's Order")

        .fullScreenCover(isPresented: $showChatAI) {
            ChatGPT()
            .environmentObject(DM)
            .environmentObject(VM)
        }}}}
