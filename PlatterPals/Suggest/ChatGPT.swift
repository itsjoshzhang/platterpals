import SwiftUI

struct ChatGPT: View {

    // ## TRACK INFO ## \\
    @State var loading = false
    @Binding var showGPT: Bool
    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    // ## SHOW CHATS ## \\

    var body: some View {
        NavigationStack {
        if loading {

        let system = MessageRow(
            isInteractingWithChatGPT: false, sendImage: "openai",
            send: .rawText("Hi! I'm your PlatterPal, an AI that finds food and restaurants. Tap Find My Food to get started!"),
            responseImage: "logo")

        ContentView(system: system)
            .environmentObject(DM)
            .environmentObject(VM)

        // ## MODIFIERS ## \\

        .navigationTitle("Your AI")
        .background {
            Back()
        }
        .toolbar {
        ToolbarItem {
        Button("\(Image(systemName: "arrowshape.turn.up.left"))") {
            withAnimation {
                VM.clearMessages()
                showGPT = false
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(VM.isInteractingWithChatGPT)

        }}} else {
            Text("").onAppear {
            withAnimation {
                loading = true
            }}}}}}

struct ContentView: View {

    // ## TRACK INFO ## \\
    var system: MessageRow
    @FocusState var focus: Bool
    @State var showOrders = false
    @State var showHelp = false
    @State var text = ""

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var VM: ViewModel

    // ## SETUP VIEW ## \\

    var body: some View {
        ScrollViewReader { proxy in
            let rest = VM.messages.last?.responseText ?? ""
            let item = rest.lowercased().contains("item")

        VStack(spacing: 0) {
        ScrollView {
        LazyVStack(spacing: 0) {

        ForEach([system] + VM.messages) { row in
            MessageRowView(message: row) { row in
                Task { @MainActor in
                    await VM.retry(message: row)
                }}}

        // ## CLICKABLES ## \\

        if VM.messages.isEmpty {
            Button("Find My Food") {
                send(text: "Find a menu item using what I told you.")
            }
            .buttonStyle(.borderedProminent)
        }
        if let last = VM.messages.last {
        if last.isInteractingWithChatGPT {
            ProgressView()
                .tint(.pink)
                .padding(16)

        } else {
        Button("Add to Orders") {
        Task { @MainActor in

            VM.inputMessage =
"Format the first menu item from your reply as ##menu item; restaurant name##"

            showHelp = false
            await VM.sendTapped(show: false)
            showOrders = true
            }
        }
        .foregroundColor(item ? .pink: .secondary)
        .buttonStyle(.bordered)
        .padding(16)

        // ## CONVO LOGIC ## \\

        HStack(spacing: 0) {
        Text("Or find another: ")
            .foregroundColor(.secondary)

        if item {
            Button("Menu item") {
                send(text: "Find another menu item at this restaurant.")
            }
            Text(" • ")
        }
        Button("Restaurant") {
            send(text: "Find another restaurant.")
            }
        }
        .font(.subheadline)
        .padding(.bottom, 16)
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
            showHelp = false
            await VM.sendTapped(show: show)
        }
    }
    // ## SHOW HELP ## \\

    func bottomView(proxy: ScrollViewProxy) -> some View {
        VStack {
        Group {
        if showHelp {
            if VM.messages.isEmpty {
                Text("Your instructions: " + VM.api.instructions)
            } else {
                Text(
        """
        Ask your PlatterPal about hours, contact info, or directions!
        You can also provide info more complex than our form can take.
        This is an AI language model. Not all replies may be accurate.
        """
        )}} else {
            HStack(spacing: 0) {
            Text("Order on ")

            Link(destination: URL(string:
                "https://apps.apple.com/app/id719972451")!) {
                Text("DoorDash")
                    .foregroundColor(.pink)
            }
            Text(" • ")
            Link(destination: URL(string:
                "https://apps.apple.com/app/id1196524786")!) {
                Text("SnackPass")
                    .foregroundColor(.pink)
            }}}}
        .font(.subheadline)
        .foregroundColor(.secondary)
        .frame(width: UIwidth-32)

        HStack(spacing: 0) {
        Image(systemName: "questionmark.circle")
            .resizable()
            .foregroundColor(.secondary)
            .frame(width: 24, height: 24)

            .padding(.leading, 8)
            .onTapGesture {
                withAnimation {
                    showHelp.toggle()
                }
            }
        // ## TEXTFIELDS ## \\

        HStack {
        TextField("Ask me anything!", text: $text, axis: .vertical)
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
                scrollToBottom(proxy: proxy)
                send(text: text)
                focus = false
                text = ""
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        // ## FUNCTIONS ## \\

        .disabled(text.isEmpty)
        }
        }
        .padding(8)
        .background(UIgray)
        .cornerRadius(32)
        .padding(.bottom, 8)
        .padding(.horizontal, 8)
    }}}
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = VM.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}
