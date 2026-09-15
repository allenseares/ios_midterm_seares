import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var familyController: FamilyController

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                if familyController.group == nil {
                    NoGroupPlaceholder()
                } else if familyController.boughtItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No purchases yet")
                            .font(.headline)
                        Text("Items marked as bought will show up here.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(familyController.boughtItems) { item in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.brandGreen)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.headline)
                                        .strikethrough(color: .gray)
                                    HStack(spacing: 6) {
                                        Text("Qty: \(item.qty)")
                                        Text("•")
                                        MemberAvatar(name: item.boughtByName ?? "?", size: 16)
                                        Text("Bought by \(item.boughtByName ?? "someone")")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    if let boughtAt = item.boughtAt {
                                        Text("\(boughtAt, style: .relative) ago")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { offsets in
                            offsets.map { familyController.boughtItems[$0] }
                                .forEach { familyController.deleteItem($0) }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(FamilyController())
}
