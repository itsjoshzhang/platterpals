import SwiftUI

struct Splash: View {
    
    @State var size = 0.9
    @State var opacity = 0.0
    @State var showLogin = false
    @StateObject var dm = DataManager()
    
    var body: some View {
        if showLogin {
            Login()
                .environmentObject(dm)
        } else {
            content
        }
    }
    var content: some View {
        VStack(spacing: 16.0) {
            Image("logo")
            
            Text("PlatterPals")
                .font(.custom("Lobster", size: 48.0))
                .foregroundColor(.pink).bold()
            
            ProgressView()
                .tint(.pink)
                .scaleEffect(2.0)
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                size = 1.0
                opacity = 1.0
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showLogin = true
                }}}}}


struct Splash2: View {
    
    @State var size = 0.9
    @State var opacity = 0.0
    @State var progress = 0.0
    @State var showOrder = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16.0) {
                
                Image("logo")
                Text("PlatterPals")
                    .font(.custom("Lobster", size: 48.0))
                    .foregroundColor(.pink)
                
                Text("Loading the perfect dish...")
                    .font(.headline)
                    .foregroundColor(.pink)
                
                ProgressView()
                    .tint(.pink)
                    .scaleEffect(2.0)
                    .padding(20.0)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    size = 1.0
                    opacity = 1.0
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showOrder) {
                Order()
                    .environmentObject(dm)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    showOrder = true
                }}}}}


struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
            .environmentObject(DataManager())
        Splash2()
            .environmentObject(DataManager())
    }
}
