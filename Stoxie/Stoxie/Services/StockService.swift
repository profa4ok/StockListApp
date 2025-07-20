import Foundation

final class StockService {
    static let shared = StockService()
    
    private let apiKey = "d1tbgd9r01qr2iith3a0d1tbgd9r01qr2iith3ag"
    private let baseUrl = "https://finnhub.io/api/v1"
    
    // Примерный список популярных тикеров
    private let tickers = ["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "YNDX", "BAC", "MA", "APPF", "VISA"]
    
    func fetchStocks(completion: @escaping ([Stock]) -> Void) {
        var stocks: [Stock] = []
        let group = DispatchGroup()
        
        for symbol in tickers {
            group.enter()
            
            fetchStock(for: symbol) { stock in
                if let stock = stock {
                    stocks.append(stock)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(stocks)
        }
    }
    
    private func fetchStock(for symbol: String, completion: @escaping (Stock?) -> Void) {
        let quoteUrl = "\(baseUrl)/quote?symbol=\(symbol)&token=\(apiKey)"
        let profileUrl = "\(baseUrl)/stock/profile2?symbol=\(symbol)&token=\(apiKey)"
        
        var name: String?
        var logo: String?
        var price: Double?
        var change: Double?
        
        let group = DispatchGroup()
        
        // Профиль
        group.enter()
        URLSession.shared.dataTask(with: URL(string: profileUrl)!) { data, _, _ in
            defer { group.leave() }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                name = json["name"] as? String
                logo = json["logo"] as? String
            }
        }.resume()
        
        // Цена
        group.enter()
        URLSession.shared.dataTask(with: URL(string: quoteUrl)!) { data, _, _ in
            defer { group.leave() }
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                price = json["c"] as? Double
                change = json["dp"] as? Double
            }
        }.resume()
        
        group.notify(queue: .main) {
            if let name = name {
                let stock = Stock(
                    symbol: symbol,
                    name: name,
                    price: price,
                    changePercentage: change,
                    image: logo
                )
                completion(stock)
            } else {
                completion(nil)
            }
        }
    }
}
