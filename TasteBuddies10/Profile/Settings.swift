import SwiftUI

struct Settings: View {
    
	@State var items = SettingsItem.data
	@State private var showAction = false
    @Environment(\.dismiss) private var dismiss
	
	var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(value: item) {
                    Row(headline: item.headline,
                        caption: item.caption,
                        image: Image(systemName: item.imageName))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }
                }
            }
            Button("Exit app") {
                showAction = true
            }
            .buttonStyle(.borderedProminent)
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Exit app"),
                buttons: [
                .destructive(Text("Log out")),
                .destructive(Text("Switch Account")),
                .cancel(Text("Cancel"))]
            )
        }
	}
}
extension Settings {
    struct Row: View {
        
        let headline: String
        let caption: String
        let image: Image
        
        var body: some View {
            HStack(spacing: 16.0) {
                image
                    .resizable()
                    .frame(width: 24.0, height: 24.0)
                    .padding(16.0)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(headline)
                        .font(.headline)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }}}}}


struct Settings_Previews: PreviewProvider {
	static var previews: some View {
        Settings()
	}
}
