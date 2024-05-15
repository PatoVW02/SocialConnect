import SwiftUI

struct PostReplyView: View {
    let post: Post
    @State private var replyText = ""
    @State private var postViewSize: CGFloat = 24
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PostReplyViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(alignment: .top) {
                        VStack {
                            CircularProfileImageView(logoUrl: post.organization.logoUrl, size: .small)

                            Rectangle()
                                .frame(width: 2, height: postViewSize - 24)
                                .foregroundColor(Color(.systemGray4))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(post.organization.userName ?? "")
                                .fontWeight(.semibold)
                            
                            Text(post.content)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        CircularProfileImageView(logoUrl: post.organization.logoUrl, size: .small)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.organization.logoUrl ?? "")
                                .fontWeight(.semibold)
                            
                            TextField("Agrega tu respuesta...", text: $replyText, axis: .vertical)
                                .multilineTextAlignment(.leading)
                            
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        if !replyText.isEmpty {
                            Button {
                                replyText = ""
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .navigationTitle("Respuestas")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.theme.primaryText)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Publicar") {
                            Task {
                                viewModel.createReply()
                                dismiss()
                            }
                        }
                        .opacity(replyText.isEmpty ? 0.5 : 1.0)
                        .disabled(replyText.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.theme.primaryText)
                    }
                }
            }
        }
        .onAppear { setPostViewHeight() }
    }
    
    func setPostViewHeight() {
        let imageHeight: CGFloat = 40
        let captionSize = post.content.sizeUsingFont(usingFont: UIFont.systemFont(ofSize: 12))
        
        self.postViewSize = captionSize.height + imageHeight
    }
}

struct ThreadReplyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostReplyView(post: dev.post)
        }
    }
}


