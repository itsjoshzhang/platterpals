import SwiftUI

struct NewOrder: View {
    @State var text: String

    let g = GridItem(.flexible(), spacing: 10)

    var body: some View {
        VStack(spacing: 16) {
            Text(text)
                .foregroundColor(.secondary)
                .font(.subheadline)

            if let range = text.range(of: "##.*##", options: .regularExpression) {

                let trim = text[range].trimmingCharacters(in: CharacterSet(charactersIn: "#"))
                let list = trim.components(separatedBy: "; ")

                let order = list[0]
                let place = list[1]
                Text("Menu item: \(order)")
                Text("Restaurant: \(place)")

            } else {
                Text("AI reply error. Please add order manually.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            ScrollView(.horizontal) {
                let columns = [g, g, g, g, g, g]

                LazyHGrid(rows: columns, spacing: 8) {
                    ForEach(emojiList, id: \.self) { emoji in
                        Button(action: {

                            print("Button tapped: \(emoji)")
                        }) {
                            Text(emoji)
                                .font(.system(size: 24))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}
