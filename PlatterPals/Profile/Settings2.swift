import SwiftUI

struct Settings2: View {
    
    var anchor: String
    @State var toggle1 = true
    @State var toggle2 = true
    @State var toggle3 = false
    
    @State var showReset = false
    @State var showSync = false
    @State var showDelete = false
    @State var showAdmin = false
    @State var showTerms = false
    
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10.0) {
                    Group {
                        Text("Chats")
                            .font(.headline)
                            .padding(.top, 20.0)
                            .id("Chats")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
                        Text("Blocked users: None")
                        HStack {
                            Text("Allow chat notifications")
                            Spacer()
                            Toggle("", isOn: $toggle1)
                                .frame(width: 100)
                        }
                    }
                    Group {
                        Text("Feed")
                            .font(.headline)
                            .padding(.top, 20.0)
                            .id("Feed")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
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
                            .padding(.top, 20.0)
                            .id("Profile")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
                        HStack {
                            Image(dm.user.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80.0)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(dm.user.name)
                                    .font(.headline)
                                Text(dm.user.bio)
                            }
                        }
                    }
                    Group {
                        Text("Security")
                            .font(.headline)
                            .padding(.top, 20.0)
                            .id("Security")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
                        Text("Payment methods: None")
                        HStack {
                            Text(dm.user.id)
                            Spacer()
                            Button("Reset") {
                                showReset = true
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    Group {
                        Text("Account")
                            .font(.headline)
                            .padding(.top, 20.0)
                            .id("Account")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
                        Button("Sync DoorDash") {
                            showSync = true
                        }
                        .buttonStyle(.borderedProminent)
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
                            .padding(.top, 20.0)
                            .id("Terms")
                        Divider()
                            .frame(minHeight: 3.0)
                            .overlay(.pink)
                        Button("Terms and EULA") {
                            showTerms = true
                        }
                    }
                    Rectangle()
                        .fill(.white)
                        .frame(height: UIScreen.main.bounds.height)
                    Button("/") {
                        showAdmin = true
                    }
                }
            }
            .padding(.horizontal, 20.0)
            .fullScreenCover(isPresented: $showReset) {
                Forgot()
            }
            .fullScreenCover(isPresented: $showSync) {
                Sync()
            }
            .fullScreenCover(isPresented: $showAdmin) {
                Admin()
                    .environmentObject(dm)
            }
            .fullScreenCover(isPresented: $showTerms) {
                Terms()
            }
            .alert(isPresented: $showDelete) {
                Alert(title: Text("Delete account"),
                      message: Text("This will delete all your account data. Deletion may take up to 24 hours."),
                      dismissButton: .default(Text("Got it!")))
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
