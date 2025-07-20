import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var onSubmit: (String) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                if isFocused.wrappedValue {
                    text = ""
                    isFocused.wrappedValue = false
                }
            }) {
                Image(systemName: !isFocused.wrappedValue ? "magnifyingglass" : "arrow.left")
                    .foregroundColor(.black)
            }
            
            TextField("", text: $text)
                .placeholder(when: !isFocused.wrappedValue && text.isEmpty) {
                    Text("Find company or ticket")
                        .foregroundColor(.black)
                }
                .focused(isFocused)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.black)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(8)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.black.opacity(1), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.vertical, 10)
        .animation(.easeInOut(duration: 0.2), value: text)
        .onSubmit {
              onSubmit(text)
          }
    }
}
