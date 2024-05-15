//
//  OrganizationPostView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 17/10/23.
//

import SwiftUI
import Kingfisher

struct OrganizationPostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.title2)
                .bold()
            Text(post.content)
                .font(.subheadline)
            
            KFImage(URL(string: post.videoUrl))
                .resizable()
                .scaledToFit()
            
            Text("Creado el \(DateFormatter.publicationDateFormatter.string(from: post.createdAt))")
                .font(.caption)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

struct OrganizationPostView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationPostView(post: dev.post)
    }
}
