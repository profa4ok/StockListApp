import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = StockListViewModel()
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else {
                ContentView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.load {
                isLoading = false
            }
        }
    }
}
