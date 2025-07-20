import SwiftUI

struct StockRowView: View {
    let stock: Stock
    let isFavourite: Bool
    let onToggleFavourite: () -> Void
    let index: Int
    
    @State private var isVisible = false
    
    var body: some View {
        HStack {
            if let imageUrl = stock.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 40, height: 40)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 40, height: 40)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(stock.name).font(.headline).lineLimit(1)
                    Button(action: onToggleFavourite) {
                        Image(systemName: isFavourite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                Text(stock.symbol).font(.subheadline).foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let price = stock.price {
                    Text(String(format: "$%.2f", price)).bold()
                }
                HStack {
                    if let price = stock.price, let changePercentage = stock.changePercentage {
                        let changePrice = (price * changePercentage / 100)
                        let sign = changePrice >= 0 ? "+" : "-"
                        let changeText = String(format: "%@$%.2f", sign, abs(changePrice))
                        Text(changeText)
                            .foregroundColor(changePrice >= 0 ? .green : .red)
                    }
                    if let change = stock.changePercentage {
                        Text(String(format: "(%.2f%%)", change))
                            .foregroundColor(change >= 0 ? .green : .red)
                    }
                }
            }
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.3).delay(Double(index) * 0.05), value: isVisible)
        .onAppear {
            isVisible = true
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(index % 2 == 1 ? .white : .blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 10)
    }
}
