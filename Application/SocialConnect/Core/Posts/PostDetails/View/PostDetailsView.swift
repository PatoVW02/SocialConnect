import SwiftUI
import WebKit

struct PostDetailsView: View {
    @StateObject var viewModel: PostDetailsViewModel
    @State private var showReplySheet = false
    
    private var post: Post {
        return viewModel.post
    }
    
    init(post: Post) {
        self._viewModel = StateObject(wrappedValue: PostDetailsViewModel(post: post))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    CircularProfileImageView(logoUrl: post.organization.logoUrl, size: .small)
                    
                    Text(post.organization.userName ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("12m")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray3))
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color(.darkGray))
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(post.content)
                        .font(.subheadline)
                    
                    if !post.videoUrl.isEmpty {
                        WebView(urlString: post.videoUrl)
                            .frame(height: 200)
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
                .padding(.vertical)
            
            Button {
                if viewModel.starClicked {
                    viewModel.unfollowOrganization()
                } else {
                    viewModel.followOrganization()
                }
            } label: {
                ZStack{
                    Color.black
                        .cornerRadius(8)
                    
                    HStack {
                        if viewModel.starClicked {
                            Text("Dejar de seguir")
                                .tint(Color.white)
                        } else {
                            Text("Comenzar a Seguir")
                                .tint(Color.white)
                        }
                        
                        Image(systemName: viewModel.starClicked ? "star.fill" : "star")
                            .foregroundColor(viewModel.starClicked ? .yellow : .white)
                            .frame(width: 33, height: 30)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Background())
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsView(post: dev.post)
    }
}
