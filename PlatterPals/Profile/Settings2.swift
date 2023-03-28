// File: checked

import SwiftUI

struct Settings2: View {
    
    var anchor: String
    @State var toggle1 = true
    @State var toggle2 = true
    @State var toggle3 = false

    @State var showReset = false
    @State var showDelete = false
    @State var showTerms = false
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

        Group {
            Text("Chats")
                .font(.headline)
                .padding(.top, 20)
                .id("Chats")
            Div()
            Text("Blocked users: None")

            HStack {
                Text("Allow chat notifications")
                Spacer()
                Toggle("", isOn: $toggle1)
                    .frame(width: 100)
            }
        }
        Group {
            Text("Home")
                .font(.headline)
                .padding(.top, 20)
                .id("Home")
            Div()
            Text("Profile swipe history: None")

            HStack {
                Text("Allow profile suggestions")
                Spacer()
                Toggle("", isOn: $toggle2)
                    .frame(width: 100)
            }
        }
        Group {
            Text("Profile")
                .font(.headline)
                .padding(.top, 20)
                .id("Profile")
            Div()

            HStack {
// TODO: call getImage() inside onAppear() in views and assign return value to local @State vars of type UIImage

                Image(uiImage: DM.getImage(id:
                    DM.my().id, path: "avatars"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(DM.my().name)
                        .font(.headline)
                    Text(DM.my().text)
                }
            }
        }
        Group {
            Text("Security")
                .font(.headline)
                .padding(.top, 20)
                .id("Security")
            Div()
            Text("Payment methods: None")

            HStack {
                Text(DM.my().id)

                Button("Reset") {
                    showReset = true
                }
                .buttonStyle(.bordered)
            }
        }
        Group {
            Text("Account")
                .font(.headline)
                .padding(.top, 20)
                .id("Account")
            Div()

            if toggle3 {
                Button("Cancel deletion") {
                    showDelete = false
                    toggle3 = false
                }
                .buttonStyle(.bordered)

                Text("Delete account: processing")
                    .foregroundColor(.secondary)

            } else {
                Button("Delete account") {
                    showDelete = true
                    toggle3 = true
                }
                .buttonStyle(.bordered)
            }
        }
        Group {
            Text("Terms")
                .font(.headline)
                .padding(.top, 20)
                .id("Terms")
            Div()

            Button("Terms and EULA") {
                showTerms = true
            }
        }
    }
}
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showReset) {
                Reset()
                    .environmentObject(DM)
            }
            .fullScreenCover(isPresented: $showTerms) {
                Terms()
                    .environmentObject(DM)
            }
            .alert(isPresented: $showDelete) {
                Alert(title: Text("Delete account"),
                      message: Text("Deletion may take up to 24 hours."),
                      dismissButton: .default(Text("Continue")))
            }
            .onAppear {
                value.scrollTo(anchor, anchor: .top)
            }
        }
    }
}
struct Settings2_Previews: PreviewProvider {
    static var previews: some View {
        Settings2(anchor: "")
            .environmentObject(DataManager())
    }
}
