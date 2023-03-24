import SwiftUI

struct Splash: View {
    
    @State var first: Bool
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showNext = false
    @Environment(\.dismiss) var dismiss
    
    @StateObject var DM = DataManager()
    
    var body: some View {
        if showNext {
            if first {
                Login().environmentObject(DM)
            } else {
                Order().environmentObject(DM)}
        } else {
            content
        }
    }
    var content: some View {
        ZStack {
            Back()
            VStack(spacing: 16) {
                Image("logo")
                
                Text("PlatterPals")
                    .font(.custom("Lobster", size: 50))
                
                if !first {
                    Text("Finding the perfect dish...")
                        .font(.headline)
                }
                ProgressView()
                    .scaleEffect(2)
                    .tint(.pink)
                    .padding(16)
            }
            .foregroundColor(.pink)
        }
        .scaleEffect(scale)
        .opacity(opacity)

        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showNext = true
                }
            }
        }
        .toolbar {
            if !first {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash(first: true)
    }
}
