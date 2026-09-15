import SwiftUI

struct MemberAvatar: View {
    var name: String
    var size: CGFloat = 18

    var body: some View {
        Circle()
            .fill(FamilyController.color(for: name))
            .frame(width: size, height: size)
            .overlay(
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: size * 0.55, weight: .bold))
                    .foregroundColor(.white)
            )
    }
}
