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

    @State var loading = false
    @State var showGPT = false
    @State var items = [String]()
    @State var whisper = ""

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    var body: some View {
        if showGPT {
            ChatGPT(recipes: true, showGPT: $showGPT)
                .environmentObject(DM)
                .environmentObject(VM)
        } else {
            content
        }}
    var content: some View {
        VStack {
        if loading {
        Form {

        Section("Add what's in your fridge") {
        ForEach(0 ..< items.count, id: \.self) { index in
        HStack {

        TextField("Enter a food item", text: $items[index])
            .submitLabel(.done)

        if index == items.count - 1 {
            Button("\(Image(systemName: "plus.circle"))") {
                items.append("")
            }
        }}}}
        .onAppear {
            items.append("")
        }
        Section("Or speak into the mic") {
            TextField("Dictate your ingredients", text: $whisper)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.done)
            HStack {
            Spacer()
            Button("Done") {
                items.removeAll()
                for word in whisper.components(separatedBy: ",") {
                    items.append(word)
                }}
            .buttonStyle(.borderedProminent)
            .disabled(whisper.isEmpty)
            }}}
        HStack {
            Text("New: Whisper API. Tap the \(Image(systemName: "mic.fill")) in the lower right of your keyboard.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)

        Button("Get Started") {
            let intro = "You're PlatterPal, an AI that finds recipes from ingredients. "
            var text = "Here is a list of ingredients: "

            for item in items {
                if (item != "and" && item != "also") {
                    text += "\(item),"
                }
            }
            VM.api = ChatGPTAPI(aiModel: DM.aiModel, intro: intro, text: text)
            withAnimation {
                showGPT = true
                loading = false
            }}
        .buttonStyle(.borderedProminent)
        .disabled(isEmpty())
        .padding(.bottom, 8)

        } else {
            Text("").onAppear {
            withAnimation {
                loading = true
        }}}}}

    func isEmpty() -> Bool {
        for item in items {
            if !item.isEmpty {
                return false }}
        return true
    }
}
