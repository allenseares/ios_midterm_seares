import SwiftUI

struct NoGroupPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.3")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("You're not in a family yet")
                .font(.headline)
            Text("Go to the Family tab to create or join one.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
