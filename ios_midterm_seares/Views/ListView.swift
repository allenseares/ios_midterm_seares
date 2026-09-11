import SwiftUI

struct ListView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ItemRowCard(itemName: "Whole Milk", qty: 2, userName: "Sarah", userInitial: "S", userColor: .orange)
                    ItemRowCard(itemName: "Greek Yogurt", qty: 3, userName: "Mom", userInitial: "M", userColor: .pink)
                }
                .padding()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { }) {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.brandGreen)
                            .clipShape(Circle())
                            .shadow(color: .brandGreen.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ItemRowCard: View {
    var itemName: String
    var qty: Int
    var userName: String
    var userInitial: String
    var userColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(Image(systemName: "photo").foregroundColor(.gray))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(itemName).font(.headline)
                HStack(spacing: 6) {
                    Text("Qty: \(qty)").font(.subheadline).foregroundColor(.gray)
                    Text("•").foregroundColor(.gray)
                    Circle().fill(userColor).frame(width: 18, height: 18)
                        .overlay(Text(userInitial).font(.system(size: 10, weight: .bold)).foregroundColor(.white))
                    Text(userName).font(.subheadline).foregroundColor(.gray)
                }
            }
            Spacer()
            Button(action: { }) {
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

#Preview {
    ListView()
}
