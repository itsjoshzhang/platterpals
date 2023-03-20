// TODO: everything about food generating

import SwiftUI

struct Order: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                BigButton(path: 3, text: "Order with DoorDash")
                    .environmentObject(DM)
                
//      Update(id: <#T##String#>, user: <#T##String#>, image: <#T##UIImage#>, text: <#T##String#>)
//                    .environmentObject(dm)
            }
        }
        .navigationTitle("Found Your Food!")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            //DM.getImage(id: <#T##String#>, path: <#T##String#>)
        }
    }
}

struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
            .environmentObject(DataManager())
    }
}
