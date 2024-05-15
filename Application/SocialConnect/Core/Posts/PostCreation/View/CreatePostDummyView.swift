import SwiftUI

struct CreatePostDummyView: View {
    @State private var presented = false
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack { }
        .onAppear { presented = true }
        .sheet(isPresented: $presented) {
            CreatePostView(tabIndex: $tabIndex)
        }
    }
}

struct CreatePostDummyView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostDummyView(tabIndex: .constant(0))
    }
}
