import SwiftUI

struct TitleBar: View {

    var id: String
    @State var image: UIImage?
    @State var hideBar = false
    @State var showProf = false

    @EnvironmentObject var DM: DataManager

    var body: some View {
        VStack {
            let user = DM.user(id: id)
        HStack {
        Button {
            showProf = true
        } label: {
        HStack(spacing: 16) {

        RoundPic(width: 80, image: image)

        VStack(alignment: .leading, spacing: 8) {
            Text(user.name)
                .font(.title2).bold()

            Text("View Profile")
                .foregroundColor(.secondary)
                .font(.subheadline)
                .underline()
        }}}
        Spacer()
        if DM.my().id != id {
            Block(id: id)
                .environmentObject(DM)
                .padding(.bottom, -64)
            }
        }
        .padding(.horizontal, 16)
        Div()
        }
        .onAppear {
            if image == nil {
                getImage(path: "avatars")
            }
        }
        .sheet(isPresented: $showProf) {
            Profile(id: id, pad: 64, avatar: image)
                .environmentObject(DM)
        }
    }
    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
            if let data = data {
                image = UIImage(data: data)
            }}}}

struct Block: View {

    var id: String
    @State var showAlert = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Button("\(Image(systemName: "bell"))") {
            showAlert = true
        }
        .buttonStyle(.bordered)
        .confirmationDialog("", isPresented: $showAlert) {
            var data = DM.md()

            if let i = data.blocked.firstIndex(of: id) {
                Button("UNBLOCK USER") {
                    data.blocked.remove(at: i)
                    DM.editData(data: data)
                }
            } else {
                Button("Block this user") {
                    data.blocked.append(id)
                    DM.editData(data: data)
            }}}}}

struct Bubble: View {

    var message: Message
    var showDate: Bool
    @State var showTime: Bool

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let sender = (message.sender == DM.my().id)
        VStack(alignment: sender ? .trailing: .leading) {

        if showDate {
            Text(message.time.formatted(.dateTime.day().month()))
                .foregroundColor(.secondary)
                .frame(maxWidth: UIwidth)
        }
        Text(message.text)
            .padding(16)
            .background(sender ? .pink.opacity(0.25): UIgray)
            .cornerRadius(16)

            .frame(maxWidth: UIwidth, alignment: sender ?
                .trailing: .leading)
            .onLongPressGesture(minimumDuration: 0.05) {
                showTime.toggle()
            }
        if showTime {
            Text(message.time.formatted(.dateTime.hour().minute()))
                .foregroundColor(.secondary)
                .font(.caption)
            }}
        .padding(.horizontal, 16)
    }}
