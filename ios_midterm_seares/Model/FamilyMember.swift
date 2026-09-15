import Foundation
import FirebaseFirestore

/// A signed-in user. Stored in `users/{uid}`.
struct FamilyMember: Identifiable, Codable {
    @DocumentID var id: String?
    var displayName: String
    var email: String
    var groupId: String?

    var initial: String {
        String(displayName.prefix(1)).uppercased()
    }
}
