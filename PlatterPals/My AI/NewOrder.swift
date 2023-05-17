import SwiftUI

struct NewOrder: View {
    @State var text: String

    var body: some View {
        VStack(spacing: 16) {
            Text(text)
                .foregroundColor(.secondary)
                .font(.subheadline)

            if let range = text.range(of: "##.*##", options: .regularExpression) {

                let trim = text[range].trimmingCharacters(in: CharacterSet(charactersIn: "#"))
                let list = trim.components(separatedBy: ";")

                let order = list[0]
                let place = list[1]
                Text("Menu item: \(order)")
                Text("Restaurant: \(place)")

            } else {
                Text("AI response error. Add the order manually.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
    }
}
