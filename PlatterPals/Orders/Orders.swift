import SwiftUI

struct Orders: View {
    @State var text: String

    var body: some View {
        VStack {
            Text(text)
            if let range = text.range(of: "##.*##", options: .regularExpression) {

                let trim = text[range].trimmingCharacters(in: CharacterSet(charactersIn: "#"))
                let comp = trim.components(separatedBy: ";")

                Text("Menu item: \(comp[0])")
                Text("Restaurant: \(comp[1])")

            } else {
                Text("No matching section found")
            }
        }
    }
}
