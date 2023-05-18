import SwiftUI

struct TitleBar: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var image: UIImage?
    @State var hideBar = false
    @State var showProf = false

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\
    var body: some View {
        if hideBar {
            Button("\(Image(systemName: "chevron.down"))") {
            withAnimation {
            hideBar = false }}
            .buttonStyle(.bordered)
        } else {
            content }}
    var content: some View {
        VStack {
        HStack {
        Button {
            showProf = true
        } label: {
        HStack(spacing: 16) {

        // ## USER INFO ## \\

        RoundPic(width: 80, image: image)

        VStack(alignment: .leading) {
            let user = DM.user(id: id)
            Text(user.name)
                .font(.title).bold()

            Text("\(user.city), CA")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }}}
        Spacer()

        Button("\(Image(systemName: "chevron.up"))") {
            withAnimation {
                hideBar = true
            }
        }
        .buttonStyle(.bordered)

        // ## MODIFIERS ## \\

        Block(id: id)
            .environmentObject(DM)
        }
        .padding(.horizontal, 16)
        Div()
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
        .sheet(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
    }
    // ## FUNCTIONS ## \\

    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Block: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var showAlert = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Button("\(Image(systemName: "bell"))") {
            showAlert = true
        }
        .buttonStyle(.bordered)

        // ## SHOW ALERT ## \\

        .confirmationDialog("", isPresented: $showAlert) {
            var data = DM.md()
            if data.blocked.contains(id) {

            Button("UNBLOCK USER") {
            if let i = data.blocked.firstIndex(of: id) {
                data.blocked.remove(at: i)
                DM.editData(data: data)

            }}} else {
                Button("Block this user") {
                    data.blocked.append(id)
                    DM.editData(data: data)
            }}}}}

struct Bubble: View {

    // ## SETUP VIEW ## \\
    var message: Message
    @State var showTime = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let sender = (message.sender == DM.my().id)
        VStack(alignment: sender ? .trailing: .leading) {

        // ## SHOW TEXT ## \\

        Text(message.text)
            .padding(16)
            .background(sender ? .pink.opacity(0.25): .secondary)
            .cornerRadius(16)

            .frame(maxWidth: UIwidth, alignment: sender ?
                .trailing: .leading)
            .padding(.horizontal, 16)
            .gesture(
                DragGesture(minimumDistance: 50)
                .onEnded { _ in
                    showTime.toggle()
                }
            )
        // ## SHOW TIME ## \\

        if showTime {
            Text("\(message.time.formatted(.dateTime.hour().minute()))")
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .font(.caption)
            }}}}
