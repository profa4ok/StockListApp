import Foundation
import Combine

class StockListViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var favourites: Set<String> = []
    
    private let favKey = "favourite_tickers"
    
    init() {
        load()
        loadFavourites()
    }
    
//    func load() {
//        StockService.shared.fetchStocks { [weak self] stocks in
//            DispatchQueue.main.async {
//                self?.stocks = stocks
//            }
//        }
//    }
    
    func load(completion: @escaping () -> Void = {}) {
        StockService.shared.fetchStocks { [weak self] stocks in
            DispatchQueue.main.async {
                self?.stocks = stocks
                completion()
            }
        }
    }
    
    func toggleFavourite(symbol: String) {
        if favourites.contains(symbol) {
            favourites.remove(symbol)
        } else {
            favourites.insert(symbol)
        }
        saveFavourites()
    }
    
    private func loadFavourites() {
        if let saved = UserDefaults.standard.array(forKey: favKey) as? [String] {
            favourites = Set(saved)
        }
    }
    
    private func saveFavourites() {
        UserDefaults.standard.set(Array(favourites), forKey: favKey)
    }
    
    public func filteredStocks(tab: ContentView.Tab, searchText: String) -> [Stock] {
        let baseList = tab == .stock ? stocks : stocks.filter { favourites.contains($0.symbol) }
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.symbol.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
