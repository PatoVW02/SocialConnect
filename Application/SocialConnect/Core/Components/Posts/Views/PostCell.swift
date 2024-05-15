import SwiftUI

struct PostCell: View {
    var post: Post
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                
                HStack(alignment: .top, spacing: 12) {
                    NavigationLink(value: post.id) {
                        CircularProfileImageView(logoUrl: post.organization.logoUrl, size: .small)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.title)
                            .font(.footnote)
                            .fontWeight(.semibold)

                        Text(post.content)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)

                        Text("Creado en \(DateFormatter.publicationDateFormatter.string(from: post.createdAt))")
                            .font(.footnote)
                            .opacity(0.6)
                    }
                }
                .padding(.leading)
            }
            .foregroundColor(Color.theme.primaryText)
        }
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: dev.post)
    }
}
