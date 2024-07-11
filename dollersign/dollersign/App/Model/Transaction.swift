import Foundation

struct Transaction: Identifiable, Codable {
    var id: UUID
    var amount: Double
    var date: Date
    var category: String
    var description: String
    var isExpense: Bool
    var recurring: Bool
}
