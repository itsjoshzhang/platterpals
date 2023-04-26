import SwiftUI

struct Suggest: View {

    @State var place = ""
    @State var friend = "All"
    @State var cuisine = "All"
    @State var showChatAI = false
    @State var showParams = false

    @State var miles = 1
    @State var temp = 0.5
    @State var model = "gpt-4"
    @State var models = ["gpt-3", "gpt-3.5-turbo", "gpt-4"]

    // TODO: fix these model names

    @EnvironmentObject var DM: DataManager
    @StateObject var API = ViewModel(api: ChatGPTAPI())
    
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
            ForEach(["All"] + DM.md().favUsers, id: \.self) { id in
                if id == "All" {
                    Text("All")
                } else {
                    Text(DM.user(id: id).name)
                }}}

        if friend != "All" {
            VStack {
                Text("\(DM.user(id: friend).name)'s favorite foods:")
                    .font(.headline)
                Text("No favorites yet.")
                    .foregroundColor(.secondary)
            }}}

        Section("Search parameters") {

        Stepper("Search within: \(miles) mile\(miles == 1 ? "": "s")",
                value: $miles, in: 0...10, step: 1)
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
                        Text(id)
                    }
            }
            .pickerStyle(.segmented)
            }
        } else {
            Button("AI Settings") {
                withAnimation {
                    showParams = true
                }
            }
            .foregroundColor(.secondary)
            .frame(width: UIwidth, alignment: .center)
        }}}

        Button("Let's Order") {
            var text = ""
            API.api.editSets(model: model, text: text, temp: temp)
            showChatAI = true
        }
        .padding(.bottom, 16)
        .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Let's Order")

        .fullScreenCover(isPresented: $showChatAI) {
            ChatGPT()
            .environmentObject(DM)
            .environmentObject(API)
        }}}}
