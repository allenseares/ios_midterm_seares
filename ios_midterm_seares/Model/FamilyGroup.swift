import Foundation
import FirebaseFirestore

/// A family group that shares one shopping list.
struct FamilyGroup: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var inviteCode: String
    var memberIds: [String]
    var createdBy: String
    var createdAt: Date = Date()
}
