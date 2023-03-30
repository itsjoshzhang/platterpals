import SwiftUI

struct Splash: View {

    // ## TRACK INFO ## \\
    @State var first: Bool
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showNext = false

    @Environment(\.dismiss) var dismiss
    @StateObject var DM = DataManager()

    // ## OTHER VIEWS ## \\

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

            // ## TEXT & LOGO ## \\

            VStack(spacing: 16) {
                Image("logo")
                
                Text("PlatterPals")
                    .font(.custom("Lobster", size: 50))
                
                if first == false {
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

        // ## MODIFIERS ## \\

        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                scale = 1.0
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showNext = true
                }}}
        .toolbar {
            if first == false {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}
