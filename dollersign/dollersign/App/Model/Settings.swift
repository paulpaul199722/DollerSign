import Foundation

struct Settings: Codable {
    var decimalSpecifier: String
    
    static let defaultSettings = Settings(decimalSpecifier: "%.1f")
}
