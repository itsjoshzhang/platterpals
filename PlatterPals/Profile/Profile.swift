import SwiftUI

struct Profile: View {
    
    @State var bioText = ""
    @State var editInfo = false
    @State var showSync = false
    @State var showSettings = false
    @State var showUpdates = false
    
    @State var image = 5
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 16.0) {
                        
                        HStack(spacing: 16.0) {
    VStack {
        if editInfo {
            Image("pfp\(image)")
                .resizable()
                .scaledToFit()
                .frame(width: 80.0)
                .clipShape(Circle())
            
            Button("Next pic") {
                if image == 5 { image = 1 } else { image += 1 }
            }
        } else {
            Image(dm.user.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80.0)
                .clipShape(Circle())
        }
    }
    VStack(alignment: .leading) {
        Text(dm.user.bio)
        if editInfo {
            VStack {
                TextField("Write a new bio", text: $bioText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }}}}
    .padding(.horizontal, 20.0)
                        
    HStack(spacing: 16.0) {
        Button("Sync data") {
            showSync = true
        }
        .buttonStyle(.borderedProminent)
        
        if editInfo {
            Button("Save") {
                dm.addUser(dm.user.id, dm.user.name, bioText, "pfp\(image)")
                editInfo = false;
            }
            .buttonStyle(.bordered)
            Button("\(Image(systemName: "xmark.circle"))") {
                editInfo = false;
            }
                            } else {
                                Button("Edit info") {
                                    editInfo = true;
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("\(dm.user.name)'s favorite foods:")
                            .font(.headline)
                            .padding(.horizontal, 20.0)
                        Carousel(tag: dm.user.name)
                        
                        Image("cards")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.5)
                            .onTapGesture {
                                showUpdates = true
                            }
                    }
                }
                .navigationTitle("Your Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Settings") {
                            showSettings = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .fullScreenCover(isPresented: $showSync) {
                    Sync()
                        .environmentObject(dm)
                }
                .fullScreenCover(isPresented: $showSettings) {
                    Settings()
                        .environmentObject(dm)
                }
                .fullScreenCover(isPresented: $showUpdates) {
                    Updates(name: dm.user.name)
                        .environmentObject(dm)
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(image: "square.and.arrow.up", route: "upload")
                            .environmentObject(dm)
                    }
                }
            }
        }
    }
}
struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        Profile()
            .environmentObject(DataManager())
	}
}
