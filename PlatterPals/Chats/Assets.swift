// File: checked

import SwiftUI

struct TitleBar: View {
    
    var id: String
    @State var showProfile = false
    @State var showAction = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button {
                    showProfile = true
                } label: {
                    HStack(spacing: 16) {
                        Image(uiImage: DM.getImage(id: id,
                                       path: "avatars"))
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 80)
                        
                        VStack(alignment: .leading) {
                            Text(DM.find(id: id).name)
                                .font(.title).bold()
                            Text("\(DM.find(id: id).city), CA")
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
                        .frame(width: 20, height: 20)
                }
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
            }
            .padding(.horizontal, 20)
            Div()
        }
        .fullScreenCover(isPresented: $showProfile) {
            UserProf(id: id)
                .environmentObject(DM)
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
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let sender = (message.sender == DM.user().name)
        
        VStack(alignment: sender ? .trailing: .leading) {
            Section {
                Text(message.text)
                    .padding(16)
                    .background(sender ? Color.pink.opacity(0.25):
                        .secondary)
                    .cornerRadius(30)
                    .frame(maxWidth: 300, alignment: sender ?
                        .trailing: .leading)
            }
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.time.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct Assets_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TitleBar(id: "email@gmail.com")
                .environmentObject(DataManager())
        }
    }
}
