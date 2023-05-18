import SwiftUI

struct ChatGPT: View {

    // ## TRACK INFO ## \\
    @State var dismiss = false
    @State var fuckery = false
    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    // ## OTHER VIEWS ## \\
    var body: some View {
        if dismiss {
            Suggest()
                .environmentObject(DM)
        } else {
            content
        }
    }
    // ## SHOW CHATS ## \\

    var content: some View {
        NavigationStack {
        if fuckery {

        let system = MessageRow(
            isInteractingWithChatGPT: false, sendImage: "openai",
            send: .rawText("Hi! I'm your PlatterPal, an AI that finds food and restaurants. Tap Find My Food to get started!"),
            responseImage: "logo")

        ContentView(system: system)
            .environmentObject(DM)
            .environmentObject(VM)

        // ## MODIFIERS ## \\

        .navigationTitle("Your AI")
        .toolbar {
        ToolbarItem {
        Button("\(Image(systemName: "arrowshape.turn.up.left"))") {
            withAnimation {
                VM.clearMessages()
                dismiss = true
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(VM.isInteractingWithChatGPT)

        }}} else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

struct ContentView: View {

    // ## TRACK INFO ## \\
    @State var text = ""
    var system: MessageRow
    @FocusState var focus: Bool
    @State var showHelp = false
    @State var showOrders = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    // ## SETUP VIEW ## \\

    var body: some View {
        ScrollViewReader { proxy in
            let rest = (VM.messages.last?.responseText ?? "")

        VStack(spacing: 0) {
        ScrollView {
        LazyVStack(spacing: 0) {

        // ## SHOW CHATS ## \\

        ForEach([system] + VM.messages) { row in
            MessageRowView(message: row) { row in
                Task { @MainActor in
                    await VM.retry(message: row)
                }}}

        if VM.messages.isEmpty {
            Button("Find My Food") {
                send(text: "Find a menu item using what I told you.")
            }
            .buttonStyle(.borderedProminent)
        }
        // ## CONVO LOGIC ## \\

        if let last = VM.messages.last {
            if !(last.isInteractingWithChatGPT) {
                let item = (rest.contains("item") ||
                    rest.contains("##")) && !rest.contains("orry")

        Group {
        if item {
            Button("Add to Orders") {
                Task { @MainActor in
                    VM.inputMessage = "Format your last reply as ##menu item; restaurant name##"
                    await VM.sendTapped(show: true)
                    showOrders = true
                    text = ""
        }}} else {
            Button("Add to Orders") {
                showOrders = true
            }
            .foregroundColor(.secondary)
        }
        }
        .buttonStyle(.bordered)
        .padding(16)

        // ## CLICKABLES ## \\

        HStack(spacing: 8) {
        Text("Or find a:")
            .foregroundColor(.secondary)

        if item {
            Button("Menu item") {
                send(text: "Find another menu item at this restaurant.")
            }
            Text("•")
        }
        Button("Restaurant") {
            send(text: "Find another restaurant.")
        }
        }
        .font(.subheadline)
        } else {
            DotLoadingView()
        }}}}

        // ## MODIFIERS ## \\

        bottomView(proxy: proxy)
        }
        .onTapGesture {
            focus = false
        }
        .onChange(of: rest) {_ in
            scrollToBottom(proxy: proxy)
        }
        .sheet(isPresented: $showOrders) {
            NewOrder(text: rest)
                .environmentObject(DM)
        }}}

    func send(show: Bool = true, text: String) {
        Task { @MainActor in
            VM.inputMessage = text
            await VM.sendTapped(show: show)
            self.text = ""
        }
    }
    // ## SHOW HELP ## \\

    func bottomView(proxy: ScrollViewProxy) -> some View {
        VStack {
        if showHelp {

        Text("Your instructions: " + VM.api.instructions)
            .foregroundColor(.secondary)
            .font(.subheadline)
            .padding(.horizontal, 16)
        }
        HStack {
        Image(systemName: "questionmark.circle")
            .resizable()
            .foregroundColor(.secondary)
            .frame(width: 24, height: 24)
            .onTapGesture {
                withAnimation {
                    showHelp.toggle()
                }
            }
        HStack {

        // ## TEXTFIELD ## \\

        TextField("Send a message", text: $text, axis: .vertical)
            .padding(.leading, 8)
            .focused($focus)
            .lineLimit(8)
            .onTapGesture {
                focus = true
            }
        if VM.isInteractingWithChatGPT {
            DotLoadingView()
        } else {
        Button {
            focus = false
            scrollToBottom(proxy: proxy)
            send(text: text)
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
        // ## MODIFIERS ## \\

        .disabled(text.isEmpty)
        }
        }
        .padding(8)
        .background(UIgray)
        .cornerRadius(32)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }}}
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = VM.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}
