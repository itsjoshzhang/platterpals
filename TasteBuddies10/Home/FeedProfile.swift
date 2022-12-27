import SwiftUI

struct FeedProfile: View {
    
    @State private var showAction = false
    @State private var showNewChat = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    HStack(spacing: 16.0) {
                        
                        Image("Albert")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 80)
                            .padding(.leading, 20.0)
                        
                        Text("I don't like writing bio's")
                    }
                    
                    HStack(spacing: 16.0) {
                        Button("Follow", action: {})
                        .buttonStyle(.borderedProminent)
                        
                        Button("Notifications", action: {
                            showAction = true
                        })
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Top 3 Favorite Foods:")
                        .font(.headline)
                        .padding(.horizontal, 20.0)
                    
                    Carousel()
                    Grid()
                }
            }
            .navigationTitle("Albert Y.")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("< Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send a Chat") {
                        showNewChat = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showNewChat) {
                ChatDM()
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"), buttons: [
                    .destructive(Text("Don't show their posts")),
                    .default(Text("Don't show them my posts")),
                    .cancel(Text("Cancel")),
                ])}}}}


struct FeedProfile_Previews: PreviewProvider {
	static var previews: some View {
        FeedProfile()
	}
}
