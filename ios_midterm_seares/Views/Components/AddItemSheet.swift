import SwiftUI

struct AddItemSheet: View {
    @EnvironmentObject var familyController: FamilyController
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var qty = 1

    var body: some View {
        NavigationView {
            Form {
                Section("Item") {
                    TextField("e.g. Whole Milk", text: $name)
                    Stepper("Quantity: \(qty)", value: $qty, in: 1...99)
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        familyController.addItem(name: name, qty: qty)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .accentColor(.brandGreen)
    }
}
