import SwiftUI

struct ListView: View {
    @EnvironmentObject var familyController: FamilyController
    @State private var showAddItem = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                if familyController.group == nil {
                    NoGroupPlaceholder()
                } else if familyController.pendingItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("Nothing to buy yet")
                            .font(.headline)
                        Text("Tap + to add something for the family to buy.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(familyController.pendingItems) { item in
                                ItemRowCard(item: item) {
                                    withAnimation {
                                        familyController.markBought(item)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }

                if familyController.group != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { showAddItem = true }) {
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
            .navigationTitle(familyController.group?.name ?? "List")
            .sheet(isPresented: $showAddItem) {
                AddItemSheet()
                    .environmentObject(familyController)
            }
        }
    }
}

#Preview {
    ListView()
        .environmentObject(FamilyController())
}
