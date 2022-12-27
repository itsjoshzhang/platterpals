import SwiftUI

struct Profile: View {
    @State private var showSettings = false
    @State private var showPosts = false
    @State private var showAction = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    HStack(spacing: 16.0) {
                        
                        Image("Josh")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 80)
                            .padding(.leading, 20.0)
                        
                        Text("I don't like writing bio's either")
                    }
                    HStack(spacing: 16.0) {
                        Button("Sync data", action: {
                            showAction = true
                        })
                        .buttonStyle(.borderedProminent)
                        
                        Button("Edit bio", action: {})
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Top 3 Favorite Foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Carousel()
                    Grid()
                        .onTapGesture {
                            showPosts = true
                        }
                }
            }
            .navigationTitle("Josh Z.")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showSettings = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showSettings) {
                Settings()
            }
            .fullScreenCover(isPresented: $showPosts) {
                ProfilePosts()
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Sync Data"), buttons: [
                    .destructive(Text("Log in to DoorDash")),
                    .default(Text("Upload DoorDash data")),
                    .cancel(Text("Cancel")),
                ])}}}}


struct Profile_Previews: PreviewProvider {
	static var previews: some View {
        Profile()
	}
}
