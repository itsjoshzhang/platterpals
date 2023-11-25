import SwiftUI
import Firebase

struct Splash: View {

    @State var scale = 0.9
    @State var opacity = 0.0
    @State var update = false
    @State var showNext = false

    @StateObject var DM = DataManager()
    @StateObject var MD = MapsData()

    var body: some View {
        if showNext {
            Login()
                .environmentObject(DM)
                .environmentObject(MD)
        } else {
            content
        }}
    var content: some View {
        VStack(spacing: 16) {

        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: UIwidth - 32)

        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))

        ProgressView()
            .scaleEffect(2)
            .tint(.pink)
            .padding(16)
        }
        .frame(width: UIwidth)
        .background {
            Back()
        }
        .foregroundColor(.pink)
        .scaleEffect(scale)
        .opacity(opacity)
        .sheet(isPresented: $update) {
            Version(showNext: $showNext)
                .presentationDetents([.medium])
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                opacity = 1.0
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if DM.version != VERSION {
                update = true
            } else {
                withAnimation {
                    showNext = true
                }}}}}}

struct Version: View {
    @Binding var showNext: Bool

    var body: some View {
        VStack(spacing: 16) {

        Image("appstore")
            .resizable()
            .scaledToFit()
            .frame(width: UIwidth / 2)

        Text("An update to PlatterPals is here!")
            .foregroundColor(.pink)
            .font(.headline)

        HStack(spacing: 0) {
            Text("Download now from the ")
                .foregroundColor(.secondary)

            Link(destination: URL(string:
                "https://apps.apple.com/app/id1667418651")!) {
                Text("App Store.")
            }}}
        .frame(width: UIwidth)
        .background {
            Back()
        }
        .onDisappear {
            withAnimation {
                showNext = true
            }}}}
