import SwiftUI

struct ItemRowCard: View {
    var item: ShoppingItem
    var onBought: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(Image(systemName: "photo").foregroundColor(.gray))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.headline)
                HStack(spacing: 6) {
                    Text("Qty: \(item.qty)").font(.subheadline).foregroundColor(.gray)
                    Text("•").foregroundColor(.gray)
                    MemberAvatar(name: item.addedByName, size: 18)
                    Text(item.addedByName).font(.subheadline).foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: onBought) {
                Text("Bought!")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.brandGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.brandGreen.opacity(0.15))
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}
