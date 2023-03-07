// File: checked

import SwiftUI

struct Splash: View {
    
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showLogin = false
    
    @StateObject var DM = DataManager()
    
    var body: some View {
        if showLogin {
            Login()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        VStack(spacing: 16) {
            Image("logo")
            
            Text("PlatterPals")
                .font(.custom("Lobster", size: 50))
                .foregroundColor(.pink).bold()
            
            ProgressView()
                .tint(.pink)
                .scaleEffect(2)
        }
        .scaleEffect(scale)
        .opacity(opacity)
        
        .onAppear {
            withAnimation(.easeIn(duration: 1)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showLogin = true
                }}}}}


struct Splash2: View {
    
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showOrder = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        if showOrder {
            Order()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("logo")
                
                Text("PlatterPals")
                    .font(.custom("Lobster", size: 50))
                    .foregroundColor(.pink)
                
                Text("Finding the perfect dish...")
                    .font(.headline)
                    .foregroundColor(.pink)
                
                ProgressView()
                    .tint(.pink)
                    .scaleEffect(2)
                    .padding(20)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            
            .onAppear {
                withAnimation(.easeIn(duration: 1)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showOrder = true
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }}}}}}


struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
        Splash2()
            .environmentObject(DataManager())
    }
}
