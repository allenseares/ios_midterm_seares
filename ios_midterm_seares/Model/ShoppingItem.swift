import Foundation
import FirebaseFirestore

/// An item on the shared list. Stored in `groups/{groupId}/items/{id}`.
struct ShoppingItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var qty: Int
    var addedBy: String
    var addedByName: String
    var isBought: Bool = false
    var boughtBy: String?
    var boughtByName: String?
    var boughtAt: Date?
    var createdAt: Date = Date()
}
