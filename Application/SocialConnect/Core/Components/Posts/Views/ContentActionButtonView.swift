import SwiftUI

struct ContentActionButtonView: View {
    @ObservedObject var viewModel: ContentActionButtonViewModel
    @State private var showReplySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 16) {
                Button {
                    showReplySheet.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                }
            }
            .foregroundStyle(Color.theme.primaryText)
        }
        .sheet(isPresented: $showReplySheet) {
            if let post = viewModel.post {
                PostReplyView(post: post)
            }
        }
    }
}

// Vista previa de ContentActionButtonView
struct ContentActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ContentActionButtonView(viewModel: ContentActionButtonViewModel(post: dev.post))
    }
}
