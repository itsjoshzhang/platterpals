import SwiftUI

struct TitleBar: View {
    
    var user: String
    @State var showProfile = false
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                Button {
                    showProfile = true
                } label: {
                    HStack(spacing: 20.0) {
                        Image(userData[user] ?? "logo")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80.0)
                        
                        VStack(alignment: .leading) {
                            Text(user)
                                .font(.title).bold()
                            Text("Active \(Int.random(in: 1..<60)) min ago")
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
                    Image(systemName: "chevron.left.circle")
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
            }
            .padding(.horizontal, 20.0)
            Divider()
                .frame(minHeight: 3)
                .overlay(.pink)
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
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
    
    var body: some View {
        VStack(alignment: message.sender ? .trailing: .leading) {
            Section {
                Text(message.text)
                    .padding(20.0)
                    .background(message.sender ? Color.pink.opacity(0.25):
                                Color.gray.opacity(0.25))
                    .cornerRadius(30.0)
                    .frame(maxWidth: 300,
                           alignment: message.sender ? .trailing: .leading)
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
        .frame(maxWidth: .infinity,
               alignment: message.sender ? .trailing: .leading)
        .padding(.horizontal, 20.0)
    }
}


struct Assets_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16.0) {
            
            TitleBar(user: "Josh Z")
            Bubble(message: Message(id: "id",
                text: "Hello, world!", sender: true, time: Date()))
        }
    }
}
