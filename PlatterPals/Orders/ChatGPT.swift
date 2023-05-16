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
            isInteractingWithChatGPT: true, sendImage: "openai",
            send: .rawText("Hi! I'm your PlatterPal, an AI that finds food and restaurants. Tap Find My Food to get started!"),
            responseImage: "logo")

        ContentView(system: system, vm: vm)
            .navigationTitle("Your AI")

        // ## MODIFIERS ## \\

        .toolbar {
        ToolbarItem {
        Button("\(Image(systemName: "arrowshape.turn.up.left"))") {
            withAnimation {
                vm.clearMessages()
                dismiss = true
            }}
        .buttonStyle(.borderedProminent)

        }}} else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

struct ContentView: View {

    // ## TRACK INFO ## \\
    var system: MessageRow
    @FocusState var focus: Bool
    @State var showOrders = false
    @ObservedObject var vm: ViewModel

    // ## SETUP VIEW ## \\
    var body: some View {
        ScrollViewReader { proxy in
        VStack(spacing: 0) {
        ScrollView {
        LazyVStack(spacing: 0) {

        // ## SHOW CHATS ## \\

        ForEach([system] + vm.messages) { m in
            if m.show {
                MessageRowView(message: m) { m in
                    Task { @MainActor in
                        await vm.retry(message: m)
                    }}}}

        if vm.messages.isEmpty {
            Button("Find My Food") {
                send(show: false, text:
                "Find a menu item using the instructions I gave you.")
            }
            .buttonStyle(.borderedProminent)
            //.shadow(color: .pink, radius: 4)
        }
        // ## CONVO LOGIC ## \\

        if let last = vm.messages.last {
            let done = !last.isInteractingWithChatGPT
            let text = last.responseText

            if done && (text?.contains("item") ?? false) {
                VStack {
                    Button("Add to My Orders") {
                        send(show: false, text:
                        "Format that as ##menu item; restaurant name##")
                        showOrders = true
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 16)

                    HStack(spacing: 16) {
                        Text("Or find another:")
                            .foregroundColor(.secondary)

                        Button("Menu item") {
                            send(text: "Find another menu item at this restaurant.")
                        }
                        Text("•")
                        Button("Restaurant") {
                            send(text: "Find another restaurant.")
                        }
                    }
                    .font(.subheadline)
                }
            } else if done {
                VStack {
                    Button("Find a menu item") {
                        send(text: "Find a menu item at this restaurant.")
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 16)

                    HStack(spacing: 16) {
                        Text("Or find another:")
                            .foregroundColor(.secondary)

                        Button("Restaurant") {
                            send(text: "Find another restaurant.")
                        }
                    }
                    .font(.subheadline)
                }}}}}

        // MARK: - MODIFIERS \\ Do not touch

        .onTapGesture {
            focus = false
        }
        Text(vm.api.systemMessage.content)
            .font(.subheadline)
            .foregroundColor(.secondary)

        Divider()
        bottomView(image: "logo", proxy: proxy)
        Spacer()
        }
        .onChange(of: vm.messages.last?.responseText) {_ in
            scrollToBottom(proxy: proxy)
        }
        .sheet(isPresented: $showOrders) {
            Orders(text: vm.messages.last?.responseText ?? "")
        }}}

    // MARK: - FUNCTIONS \\ Do not touch

    func send(show: Bool = true, text: String) {
        Task { @MainActor in
            vm.inputMessage = text
            await vm.sendTapped(show: show)
        }
    }
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {

            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            TextField("Send message", text: $vm.inputMessage, axis:
                    .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .disabled(vm.isInteractingWithChatGPT)

            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    Task { @MainActor in
                        focus = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                .disabled(vm.inputMessage.trimmingCharacters(in:
                        .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}
