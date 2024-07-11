import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var icon: String // Optional: for category icons

    init(id: UUID = UUID(), name: String, icon: String = "") {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
