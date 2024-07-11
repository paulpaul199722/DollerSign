import Foundation

struct Budget: Identifiable, Codable,Hashable {
    var id: UUID
    var category: String
    var amount: Double
    var startDate: Date
    var endDate: Date
    var usedAmount: Double = 0.0
}
