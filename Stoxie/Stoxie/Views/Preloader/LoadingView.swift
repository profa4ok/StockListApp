import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Загрузка данных...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
    }
}
