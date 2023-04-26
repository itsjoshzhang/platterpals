import SwiftUI
import AVKit

struct ChatGPT: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {

            var start = MessageRow(
                isInteractingWithChatGPT: true, sendImage: "openai",
                send: .rawText("Hi! I'm PlatterPal, your AI that finds nearby food and restaurants. Tap Find My Food to get started!"),
                responseImage: "logo")

            ContentView(start: start, vm: vm)
        .toolbar {
        ToolbarItem {
            Button("Clear") {
                //vm.clearMessages()
                dismiss()
            }
            .disabled(vm.isInteractingWithChatGPT)
        }}}}}

struct ContentView: View {

    var start: MessageRow

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        chatListView
            .navigationTitle("PlatterPal AI")
    }

    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {

                    ForEach([start] + vm.messages) { message in
                    MessageRowView(message: message) { message in
                    Task { @MainActor in
                    await vm.retry(message: message)
                    }}}}

                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                Text(vm.api.systemMessage.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                #if os(iOS) || os(macOS)
                Divider()
                bottomView(image: "logo", proxy: proxy)
                Spacer()
                #endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(
            red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
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
                #if os(iOS) || os(macOS)
                .textFieldStyle(.roundedBorder)
                #endif
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)

            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                #if os(macOS)
                .buttonStyle(.borderless)
                .keyboardShortcut(.defaultAction)
                .foregroundColor(.accentColor)
                #endif
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
