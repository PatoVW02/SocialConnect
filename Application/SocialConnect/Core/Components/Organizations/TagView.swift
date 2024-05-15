//
//  TagView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import SwiftUI

struct TagView: View {
    let tag: Tag
    let isSelected: Bool
    
    var body: some View {
            Text(tag.name)
            .font(.body)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isSelected ? Color.blue : Color.gray)
            .cornerRadius(10)
        }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: dev.tag, isSelected: false)
    }
}
