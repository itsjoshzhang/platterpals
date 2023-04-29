import SwiftUI

struct ChatGPT: View {

    @State var dismiss = false
    @State var fuckery = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        if dismiss {
            Suggest()
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {

        let system = MessageRow(
            isInteractingWithChatGPT: true, sendImage: "openai",
            send: .rawText("Hi! I'm your PlatterPal, an AI that finds food and restaurants. Tap Find My Food to get started!"),
            responseImage: "logo")

        if fuckery {
            ContentView(system: system, vm: vm)
                .navigationTitle("Your AI")

            .toolbar {
            ToolbarItem {
            Button("Restart") {
                withAnimation {
                    vm.clearMessages()
                    dismiss = true
                }}
            .buttonStyle(.borderedProminent)
            }}

        // I don't know wtf this does.
        } else {
            Text("")
            .onAppear {
            withAnimation {
                fuckery = true
            }}}}}}

struct ContentView: View {

    var system: MessageRow
    @FocusState var focus: Bool
    @State var showOrders = false
    @ObservedObject var vm: ViewModel

    var body: some View {
        ScrollViewReader { proxy in
        VStack(spacing: 0) {
        ScrollView {
        LazyVStack(spacing: 0) {

        ForEach([system] + vm.messages) { m in
            MessageRowView(message: m) { m in
                Task { @MainActor in
                    await vm.retry(message: m)
                }}}

        if vm.messages.isEmpty {
            Button("Find My Food!") {
                Task { @MainActor in
                    vm.inputMessage = "Find my food!"
                    await vm.sendTapped()
                }
            }
            .buttonStyle(.borderedProminent)
            .shadow(color: .pink, radius: 4)

        }
        if let last = vm.messages.last {
            let done = !last.isInteractingWithChatGPT
            let text = last.responseText?.lowercased()

            if (text?.contains("item") ?? false) && done {
                VStack {
                    Button("Add to my orders") {
                        Task { @MainActor in
                            vm.inputMessage = "Perfect. Format your reply as ##menu item; restaurant name##"
                            await vm.sendTapped()
                            showOrders = true
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 16)
                    .sheet(isPresented: $showOrders) {
                        Orders(text: text ?? "")
                    }

                    HStack(spacing: 16) {
                        Text("Or find another:")
                            .foregroundColor(.secondary)

                        Button("Menu item") {
                            Task { @MainActor in
                                vm.inputMessage = "Find another menu item at this restaurant."
                                await vm.sendTapped()
                            }
                        }
                        Text("•")
                        Button("Restaurant") {
                            Task { @MainActor in
                                vm.inputMessage = "Find another restaurant."
                                await vm.sendTapped()
                            }}}
                    .font(.subheadline)
                }
            } else if done {
                VStack {
                    Button("Find a menu item") {
                        Task { @MainActor in
                            vm.inputMessage = "Find a menu item at this restaurant."
                            await vm.sendTapped()
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 16)

                    HStack(spacing: 16) {
                        Text("Or find another:")
                            .foregroundColor(.secondary)

                        Button("Restaurant") {
                            Task { @MainActor in
                                vm.inputMessage = "Find another restaurant."
                                await vm.sendTapped()
                            }}}
                    .font(.subheadline)
                }}}}}
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
        }}}

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
