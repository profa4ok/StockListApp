import SwiftUI

struct RecentAndPopularTagsView: View {
    let popularTags: [String]
    let recentSearches: [String]
    @Binding var searchText: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Popular Request")
                    .font(.headline)
                    .padding(.horizontal)

                TagGridView(tags: popularTags, searchText: $searchText)

                if !recentSearches.isEmpty {
                    Text("You've searched for this")
                        .font(.headline)
                        .padding(.horizontal)

                    TagGridView(tags: recentSearches, searchText: $searchText)
                }
            }
            .padding(.top)
        }
    }
}

