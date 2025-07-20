import SwiftUI

struct TabSelectorView: View {
    var selectedTab: ContentView.Tab
    var onSelect: (ContentView.Tab) -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Button(action: { onSelect(.stock) }) {
                Text("Stocks")
                    .padding(.vertical, 12)
                    .foregroundColor(selectedTab == .stock ? .black : .gray)
                    .font(.system(size: selectedTab == .stock ? 24 : 14, weight: .bold))
            }
            .buttonStyle(FastTapButtonStyle())

            Button(action: { onSelect(.favourite) }) {
                Text("Favourite")
                    .padding(.vertical, 12)
                    .foregroundColor(selectedTab == .favourite ? .black : .gray)
                    .font(.system(size: selectedTab == .favourite ? 24 : 14, weight: .bold))
            }
            .buttonStyle(FastTapButtonStyle())

            Spacer()
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}
