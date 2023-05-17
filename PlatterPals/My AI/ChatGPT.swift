import SwiftUI

struct ChatGPT: View {

    // ## TRACK INFO ## \\
    @State var dismiss = false
    @State var fuckery = false
    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var vm: ViewModel

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

        ContentView(system: system, vm: vm)

        // ## MODIFIERS ## \\

        .navigationTitle("Your AI")
        .toolbar {
        ToolbarItem {
        Button("\(Image(systemName: "arrowshape.turn.up.left"))") {
            withAnimation {
                vm.clearMessages()
                dismiss = true
            }
        }
        .buttonStyle(.borderedProminent)

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

    @ObservedObject var vm: ViewModel

    // ## SETUP VIEW ## \\
    var body: some View {
        ScrollViewReader { proxy in
        let rest = vm.messages.last?.responseText
        VStack(spacing: 0) {
        ScrollView {
        LazyVStack(spacing: 0) {

        // ## SHOW CHATS ## \\

        ForEach([system] + vm.messages) { row in
            MessageRowView(message: row) { row in
                Task { @MainActor in
                    await vm.retry(message: row)
                }}}

        if vm.messages.isEmpty {
            Button("Find My Food") {
                send(text: "Find a menu item using what I told you.")
            }
            .buttonStyle(.borderedProminent)
        }
        // ## CONVO LOGIC ## \\

        if let last = vm.messages.last {
            let done = !last.isInteractingWithChatGPT
            let item = last.responseText?.contains("item") ?? false
        if done {

        Button("Add to Orders") {
        if item {
            Task { @MainActor in
                vm.inputMessage = "Format your last reply as ##menu item; restaurant name##"
                await vm.sendTapped(show: false)
            }
        }
        showOrders = true
        }
        .foregroundColor(item ? .pink: .secondary)
        .buttonStyle(.bordered)
        .padding(16)

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
        // ## MODIFIERS ## \\

        .font(.subheadline)
        } else {
            DotLoadingView()
        }}}}
        bottomView(proxy: proxy)
        }
        .onTapGesture {
            focus = false
        }
        .onChange(of: rest) {_ in
            scrollToBottom(proxy: proxy)
        }
        .sheet(isPresented: $showOrders) {
            NewOrder(text: rest ?? "")
                .presentationDetents([.medium])
        }}}

    func send(show: Bool = true, text: String) {
        Task { @MainActor in
            vm.inputMessage = text
            await vm.sendTapped(show: show)
        }
    }
    // ## SHOW HELP ## \\

    func bottomView(proxy: ScrollViewProxy) -> some View {
        VStack {
        if showHelp {

        Text("Your instructions: " + vm.api.instructions)
            .foregroundColor(.secondary)
            .font(.subheadline)
            .padding(.horizontal, 16)
        }
        HStack {
        Image(systemName: "questionmark.circle")
            .resizable()
            .foregroundColor(.secondary)
            .frame(width: 20, height: 20)
            .onTapGesture {
                withAnimation {
                    showHelp.toggle()
                }
            }
        // ## TEXTFIELD ## \\

        TextField("Send a message", text: $text, axis: .vertical)
            .padding(.leading, 8)
            .focused($focus)
            .lineLimit(8)
            .onTapGesture {
                focus = true
            }
        if vm.isInteractingWithChatGPT {
            DotLoadingView()
        } else {
        Button {
            focus = false
            scrollToBottom(proxy: proxy)
            send(text: text)
            // MARK: - add mainactor task back if this fucks up
        } label: {
            Image(systemName: "paperplane.circle.fill")
                .padding(8)
                .cornerRadius(16)
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
    }
    }
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}
