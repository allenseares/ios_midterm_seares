import SwiftUI

struct FamilyView: View {
    @EnvironmentObject var familyController: FamilyController

    var body: some View {
        NavigationView {
            Group {
                if let group = familyController.group {
                    GroupDetailView(group: group)
                } else {
                    JoinOrCreateView()
                }
            }
            .navigationTitle("Family")
            .alert("Oops", isPresented: Binding(
                get: { familyController.errorMessage != nil },
                set: { if !$0 { familyController.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(familyController.errorMessage ?? "")
            }
        }
    }
}

/// Shown when the user is not in any group yet.
struct JoinOrCreateView: View {
    @EnvironmentObject var familyController: FamilyController
    @State private var familyName = ""
    @State private var inviteCode = ""

    var body: some View {
        Form {
            Section {
                TextField("Family name (e.g. The Searés)", text: $familyName)
                Button(action: { familyController.createGroup(name: familyName) }) {
                    Label("Create Family", systemImage: "plus.circle.fill")
                        .foregroundColor(.brandGreen)
                }
                .disabled(familyName.trimmingCharacters(in: .whitespaces).isEmpty)
            } header: {
                Text("Start a new family")
            } footer: {
                Text("You'll get an invite code to share with everyone.")
            }

            Section {
                TextField("6-character code", text: $inviteCode)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                Button(action: { familyController.joinGroup(code: inviteCode) }) {
                    Label("Join Family", systemImage: "person.badge.plus")
                        .foregroundColor(.brandGreen)
                }
                .disabled(inviteCode.trimmingCharacters(in: .whitespaces).count != 6)
            } header: {
                Text("Join an existing family")
            } footer: {
                Text("Ask a family member for their invite code.")
            }
        }
    }
}

/// Shown when the user belongs to a group.
struct GroupDetailView: View {
    @EnvironmentObject var familyController: FamilyController
    var group: FamilyGroup
    @State private var showLeaveConfirm = false

    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Invite code")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(group.inviteCode)
                            .font(.system(.title, design: .monospaced).weight(.bold))
                            .foregroundColor(.brandGreen)
                    }
                    Spacer()
                    ShareLink(item: "Join our family \"\(group.name)\" on FamList! Invite code: \(group.inviteCode)") {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                            .foregroundColor(.brandGreen)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text(group.name)
            } footer: {
                Text("Share this code so family members can join.")
            }

            Section("Members (\(familyController.members.count))") {
                ForEach(familyController.members) { member in
                    HStack(spacing: 12) {
                        MemberAvatar(name: member.displayName, size: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(member.displayName).font(.headline)
                                if member.id == familyController.currentMember?.id {
                                    Text("You")
                                        .font(.caption2.weight(.semibold))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.brandGreen.opacity(0.15))
                                        .foregroundColor(.brandGreen)
                                        .cornerRadius(6)
                                }
                            }
                            Text(member.email).font(.caption).foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }

            Section {
                Button(role: .destructive) {
                    showLeaveConfirm = true
                } label: {
                    HStack {
                        Text("Leave Family")
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
        }
        .confirmationDialog("Leave \(group.name)?", isPresented: $showLeaveConfirm, titleVisibility: .visible) {
            Button("Leave", role: .destructive) { familyController.leaveGroup() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You'll no longer see the shared list.")
        }
    }
}

#Preview {
    FamilyView()
        .environmentObject(FamilyController())
}
