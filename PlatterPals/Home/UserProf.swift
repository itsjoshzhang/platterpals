// File: checked

import SwiftUI

struct UserProf: View {

    var id: String
    @State var showAction = false
    @State var showChatDM = false
    @State var showFollow = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            let name = DM.find(id: id).name

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {

                        Image(uiImage: DM.getImage(id: id, path: "avatars"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(Circle())
                        
                        Text(name)
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 16) {
                        var list = DM.data().following

                        if list.contains(id) {
                            Button("Following") {

                                if let index = list.firstIndex(of: id) {
                                    list.remove(at: index)
                                }
                            }
                            .buttonStyle(.bordered)

                        } else {
                            Button("Follow \(Image(systemName: "heart"))") {
                                list.append(id)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Button("\(Image(systemName: "bell"))") {
                            showAction = true
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("\(name)'s favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20)
                }
            }
            .navigationTitle(name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send chat") {
                        showChatDM = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showChatDM) {
                Convo(id: id)
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
}
struct UserProf_Previews: PreviewProvider {
	static var previews: some View {
        UserProf(id: "email@gmail.com")
            .environmentObject(DataManager())
	}
}
