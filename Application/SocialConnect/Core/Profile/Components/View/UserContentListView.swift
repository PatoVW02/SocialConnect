import SwiftUI

struct UserContentListView: View {
    @StateObject var viewModel: UserContentListViewModel
    @Namespace var animation
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Publicaciones")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .foregroundStyle(Color.theme.primaryText)
                        .frame(width: 180, height: 1)
                        .matchedGeometryEffect(id: "item", in: animation)
                }
            }
            .padding(.vertical, 4)
            
            LazyVStack {
                if viewModel.posts.isEmpty {
                    Text("Publicaciones")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.posts) { post in
                        PostCell(post: post)
                    }
                    .transition(.move(edge: .leading))
                }
            }
            
            .padding(.vertical, 8)
        }
    }
}

struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(viewModel: UserContentListViewModel(user: dev.user))
    }
}
