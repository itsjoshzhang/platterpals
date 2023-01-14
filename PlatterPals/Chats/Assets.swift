import SwiftUI

struct TitleBar: View {
    
    var user: String
    @State var showProfile = false
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        VStack {
            HStack(spacing: 16.0) {
                Button {
                    showProfile = true
                } label: {
                    HStack(spacing: 16.0) {
                        Image(dm.fetchData(name: user, route: true))
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80.0)
                        
                        VStack(alignment: .leading) {
                            Text(user)
                                .font(.title).bold()
                            Text("Active now")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    showAction = true
                } label: {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.0)
                }
            }
            .padding(.horizontal, 20.0)
            Divider()
                .frame(minHeight: 3.0)
                .overlay(.pink)
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
                .environmentObject(dm)
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Notifications"),
                buttons: [
                .destructive(Text("Block this user")),
                .default(Text("Mute notifications")),
                .cancel(Text("Cancel"))]
            )
        }
    }
}
struct Bubble: View {
    
    var message: Message
    @State var showTime = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        let sender = (message.sender == dm.user.name)
        
        VStack(alignment: sender ? .trailing: .leading) {
            Section {
                Text(message.text)
                    .padding(20.0)
                    .background(sender ? Color.pink.opacity(0.25):
                                Color(.secondarySystemFill))
                    .cornerRadius(30.0)
                    .frame(maxWidth: 300,
                           alignment: sender ? .trailing: .leading)
            }
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.time.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20.0)
            }
        }
        .frame(maxWidth: .infinity, alignment: sender ? .trailing: .leading)
        .padding(.horizontal, 20.0)
    }
}


struct Assets_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TitleBar(user: "Josh Z")
                .environmentObject(DataManager())
        }
    }
}
