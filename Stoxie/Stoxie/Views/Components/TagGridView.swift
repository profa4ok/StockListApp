import SwiftUI

struct TagGridView: View {
    let tags: [String]
    @Binding var searchText: String
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
            ForEach(tags, id: \.self) { tag in
                Button(action: {
                    searchText = tag
                }) {
                    Text(tag)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
    }
}
