import Foundation

struct Stock: Identifiable, Codable, Equatable {
    var id: String { symbol }
    
    let symbol: String
    let name: String
    let price: Double?
    let changePercentage: Double?
    let image: String?
}
