import SwiftUI
import FirebaseFirestoreSwift

struct Select: View {

    @State var suggest = true
    @StateObject var VM = ViewModel(api: ChatGPTAPI())
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        Group {
        if suggest {
            Suggest()
                .environmentObject(DM)
                .environmentObject(VM)
        } else {
            Recipes()
                .environmentObject(DM)
                .environmentObject(VM)
        }}
        .navigationTitle("Ask Your AI")
        .toolbar {
            ToolbarItem {
                Button(suggest ? "Find Recipes": "Find Food") {
                withAnimation {
                    VM.clearMessages()
                    suggest.toggle()
                }}
            .buttonStyle(.bordered)
            }}}}}

struct Recipes: View {

    @State var showGPT = false
    @State var items = [""]
    @State var diets = [""]
    @State var algae = [""]
    @State var whisper = ""

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    var body: some View {
        VStack {
        Form {

        Section("Add what's in your fridge") {
            ForEach(0 ..< items.count, id: \.self) { index in

            HStack {
            TextField("Enter a food item", text: $items[index])
                .submitLabel(.done)

            if index == items.count - 1 {
                Button("\(Image(systemName: "plus.circle"))") {
                    items.append("")
        }}}}}
        Section("Or speak into the mic") {
            TextField("Tap the \(Image(systemName: "mic.fill")) button!", text: $whisper)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)

            HStack {
            Spacer()
            Button("Done") {
                for word in whisper.components(separatedBy: ",") {

                    let words = word.components(separatedBy: " ")
                    let purge = words.filter {
                        !["and", "also"].contains($0)
                    }
                    items.append(purge.joined(separator: " "))
                }
                whisper = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(whisper.isEmpty)
        }}
        Section("Any allergens to avoid?") {
            ForEach(0 ..< algae.count, id: \.self) { index in

            HStack {
            TextField("Enter a food item", text: $algae[index])
                .submitLabel(.done)

            if index == algae.count - 1 {
                Button("\(Image(systemName: "plus.circle"))") {
                    algae.append("")
        }}}}}
        Section("Any dietary restrictions?") {
            ForEach(0 ..< diets.count, id: \.self) { index in

            HStack {
            TextField("Enter a food item", text: $diets[index])
                .submitLabel(.done)

            if index == diets.count - 1 {
                Button("\(Image(systemName: "plus.circle"))") {
                    diets.append("")
        }}}}}}

        HStack {
        Button("Get Started") {
            let intro = "You're PlatterPal, an AI that finds recipes using foods. Do not apologize for your limitations as an AI. Use what's in your database."
            var text = "Here is a list of ingredients: "

            for word in items {
                if !word.isEmpty {
                    text += "\(word), "
                }}
            text = String(text.dropLast(2)) + "."

            if !isEmpty(array: algae) {
                text += "These are allergens to avoid: "
                for word in algae {
                    if !word.isEmpty {
                        text += "\(word), "
                    }}
                text = String(text.dropLast(2)) + "."
            }
            if !isEmpty(array: diets) {
                text += "These are dietary restrictions: "
                for word in diets {
                    if !word.isEmpty {
                        text += "\(word), "
                    }}
                text = String(text.dropLast(2)) + "."
            }
            VM.api = ChatGPTAPI(aiModel: DM.aiModel, intro: intro, text: text)
            withAnimation {
                showGPT = true
            }}
        .buttonStyle(.borderedProminent)
        .disabled(isEmpty(array: items))
        .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        }
        .fullScreenCover(isPresented: $showGPT) {
            ChatGPT(recipes: true, showGPT: $showGPT)
                .environmentObject(DM)
                .environmentObject(VM)
        }}

    func isEmpty(array: [String]) -> Bool {
        for item in array {
            if !item.isEmpty {
                return false
            }}
        return true
    }
}
