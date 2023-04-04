import SwiftUI

struct Settings2: View {
    
    var anchor: String
    @State var toggle1 = true
    @State var toggle2 = true
    @State var toggle3 = false

    @State var image: UIImage?
    @State var showReset = false
    @State var showTerms = false
    @State var showDelete = false
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        ScrollViewReader { value in
            let user = DM.my()

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
                    RoundPic(image: image, width: 160)

                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.text)
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
                    Text(user.id)

                    Button("Reset Password") {
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
                getImage(id: user.id, path: "avatars")
                value.scrollTo(anchor, anchor: .top)
            }
        }
    }
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}
}
