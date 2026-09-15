import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

/// Handles the family group, its members, and the shared shopping list.
class FamilyController: ObservableObject {
    @Published var currentMember: FamilyMember?
    @Published var group: FamilyGroup?
    @Published var members: [FamilyMember] = []
    @Published var items: [ShoppingItem] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var userListener: ListenerRegistration?
    private var groupListener: ListenerRegistration?
    private var itemsListener: ListenerRegistration?
    private var membersListener: ListenerRegistration?

    var pendingItems: [ShoppingItem] { items.filter { !$0.isBought } }
    var boughtItems: [ShoppingItem] {
        items.filter { $0.isBought }
            .sorted { ($0.boughtAt ?? .distantPast) > ($1.boughtAt ?? .distantPast) }
    }

    init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.handleAuthChange(user)
        }
    }

    deinit {
        if let authHandle { Auth.auth().removeStateDidChangeListener(authHandle) }
        userListener?.remove()
        stopListening()
    }

    // MARK: - Auth / user document

    private func handleAuthChange(_ user: FirebaseAuth.User?) {
        stopListening()
        userListener?.remove()
        userListener = nil
        currentMember = nil
        group = nil
        members = []
        items = []

        guard let user else { return }
        let userRef = db.collection("users").document(user.uid)

        // Make sure a user document exists so other members can see this person's name.
        userRef.getDocument { snapshot, _ in
            if snapshot?.exists != true {
                let name = user.displayName
                    ?? user.email?.components(separatedBy: "@").first
                    ?? "Member"
                try? userRef.setData(from: FamilyMember(displayName: name, email: user.email ?? "", groupId: nil))
            }
        }

        userListener = userRef.addSnapshotListener { [weak self] snapshot, _ in
            guard let self else { return }
            let member = try? snapshot?.data(as: FamilyMember.self)
            self.currentMember = member
            if member?.groupId != self.group?.id {
                self.listenToGroup(id: member?.groupId)
            }
        }
    }

    // MARK: - Group listeners

    private func listenToGroup(id groupId: String?) {
        stopListening()
        guard let groupId else {
            group = nil
            members = []
            items = []
            return
        }

        let groupRef = db.collection("groups").document(groupId)

        groupListener = groupRef.addSnapshotListener { [weak self] snapshot, _ in
            self?.group = try? snapshot?.data(as: FamilyGroup.self)
        }

        membersListener = db.collection("users")
            .whereField("groupId", isEqualTo: groupId)
            .addSnapshotListener { [weak self] snapshot, _ in
                self?.members = snapshot?.documents.compactMap { try? $0.data(as: FamilyMember.self) } ?? []
            }

        itemsListener = groupRef.collection("items")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, _ in
                self?.items = snapshot?.documents.compactMap { try? $0.data(as: ShoppingItem.self) } ?? []
            }
    }

    private func stopListening() {
        groupListener?.remove(); groupListener = nil
        membersListener?.remove(); membersListener = nil
        itemsListener?.remove(); itemsListener = nil
    }

    // MARK: - Group actions

    func createGroup(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { errorMessage = "Please enter a family name."; return }

        let groupRef = db.collection("groups").document()
        let newGroup = FamilyGroup(name: trimmed,
                                   inviteCode: Self.generateInviteCode(),
                                   memberIds: [uid],
                                   createdBy: uid)
        do {
            try groupRef.setData(from: newGroup)
            db.collection("users").document(uid).setData(["groupId": groupRef.documentID], merge: true)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func joinGroup(code: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let normalized = code.trimmingCharacters(in: .whitespaces).uppercased()
        guard normalized.count == 6 else { errorMessage = "Invite code must be 6 characters."; return }

        db.collection("groups")
            .whereField("inviteCode", isEqualTo: normalized)
            .limit(to: 1)
            .getDocuments { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let doc = snapshot?.documents.first else {
                    self.errorMessage = "No family found with that code."
                    return
                }
                doc.reference.updateData(["memberIds": FieldValue.arrayUnion([uid])])
                self.db.collection("users").document(uid).setData(["groupId": doc.documentID], merge: true)
            }
    }

    func leaveGroup() {
        guard let uid = Auth.auth().currentUser?.uid, let groupId = group?.id else { return }
        db.collection("groups").document(groupId).updateData(["memberIds": FieldValue.arrayRemove([uid])])
        db.collection("users").document(uid).updateData(["groupId": FieldValue.delete()])
    }

    // MARK: - Item actions

    func addItem(name: String, qty: Int) {
        guard let uid = Auth.auth().currentUser?.uid, let groupId = group?.id else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let item = ShoppingItem(name: trimmed,
                                qty: max(1, qty),
                                addedBy: uid,
                                addedByName: currentMember?.displayName ?? "Member")
        do {
            try db.collection("groups").document(groupId).collection("items").addDocument(from: item)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func markBought(_ item: ShoppingItem) {
        guard let uid = Auth.auth().currentUser?.uid, let groupId = group?.id, let itemId = item.id else { return }
        db.collection("groups").document(groupId).collection("items").document(itemId).updateData([
            "isBought": true,
            "boughtBy": uid,
            "boughtByName": currentMember?.displayName ?? "Member",
            "boughtAt": FieldValue.serverTimestamp()
        ])
    }

    func deleteItem(_ item: ShoppingItem) {
        guard let groupId = group?.id, let itemId = item.id else { return }
        db.collection("groups").document(groupId).collection("items").document(itemId).delete()
    }

    // MARK: - Helpers

    /// Consistent avatar color for a member, derived from their name.
    static func color(for name: String) -> Color {
        let palette: [Color] = [.orange, .pink, .blue, .purple, .teal, .indigo, .red, .mint]
        let index = name.unicodeScalars.reduce(0) { $0 &+ Int($1.value) } % palette.count
        return palette[abs(index)]
    }

    private static func generateInviteCode() -> String {
        let chars = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<6).map { _ in chars.randomElement()! })
    }
}
