import SwiftUI

struct ContentView: View {
    
    enum Tab {
        case stock
        case favourite
    }
    
    @State private var recentSearches = RecentSearchesManager.load()
    @ObservedObject var viewModel: StockListViewModel
    @State private var searchText = ""
    @State private var selectedTab: Tab = .stock
    @State private var scrollOffset: CGFloat = 0
    @FocusState private var isSearchFocused: Bool
    
    func addToRecentSearches(_ term: String) {
        RecentSearchesManager.add(term)
        recentSearches = RecentSearchesManager.load()
    }
    
    let popularTags = ["Apple", "Amazon", "Tesla", "Netflix", "Google"]
    
    var body: some View {
        let filteredStocks = viewModel.filteredStocks(tab: selectedTab, searchText: searchText)
        
        NavigationView {
            VStack(spacing: 0) {
                if isSearchFocused || scrollOffset >= -10 {
                    SearchBar(text: $searchText, isFocused: $isSearchFocused,   onSubmit: { term in
                        addToRecentSearches(term)
                        isSearchFocused = false
                    })
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.2), value: scrollOffset)
                }
                if isSearchFocused && searchText.isEmpty {
                    RecentAndPopularTagsView(popularTags: popularTags, recentSearches: recentSearches, searchText: $searchText)
                        .transition(.opacity)
                        .animation(.easeInOut, value: isSearchFocused)
                } else {
                    TabSelectorView(selectedTab: selectedTab) { tab in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                        isSearchFocused = false
                    }
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self,
                                                value: geo.frame(in: .named("scroll")).minY)
                                    .frame(height: 0)
                            }
                            LazyVStack(spacing: 0) {
                                ForEach(Array(filteredStocks.enumerated()), id: \.element.id) { index, stock in
                                    StockRowView (
                                        stock: stock,
                                        isFavourite: viewModel.favourites.contains(stock.symbol),
                                        onToggleFavourite: {
                                            viewModel.toggleFavourite(symbol: stock.symbol)
                                        },
                                        index: index
                                    )
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isSearchFocused = false
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = value
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(viewModel: StockListViewModel())
}


