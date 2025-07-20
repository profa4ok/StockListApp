import SwiftUI

final class RecentSearchesManager {
    private static let key = "recentSearches"

    static func load() -> [String] {
        UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }

    static func add(_ term: String) {
        var saved = load()
        saved.removeAll(where: { $0.lowercased() == term.lowercased() })
        saved.insert(term, at: 0)
        saved = Array(saved.prefix(6))
        UserDefaults.standard.set(saved, forKey: key)
    }
}
