//
//  PostActionSheetView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 05/10/23.
//

import SwiftUI
import SwiftData

struct PostActionSheetView: View {
    let post: Post
    @State private var height: CGFloat = 200
    @State private var isFollowed = true
    @Binding var selectedAction: PostActionSheetOptions?
    
    var body: some View {
        List {
            Section {
                if isFollowed {
                    PostActionSheetRowView(option: .unfavorite, selectedAction: $selectedAction)
                }
                
                PostActionSheetRowView(option: .hide, selectedAction: $selectedAction)
            }
            
            Section {
                if !isFollowed {
                    PostActionSheetRowView(option: .report, selectedAction: $selectedAction)
                        .foregroundColor(.red)
                }
            }
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(12)
        .font(.footnote)
    }
}

struct PostActionSheetRowView: View {
    let option: PostActionSheetOptions
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAction: PostActionSheetOptions?
    
    var body: some View {
        HStack {
            Text(option.title)
                .font(.footnote)
            
            Spacer()
        }
        .background(Color.theme.primaryBackground)
        .onTapGesture {
            selectedAction = option
            dismiss()
        }
    }
}

struct PostActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PostActionSheetView(post: dev.post, selectedAction: .constant(.unfavorite))
    }
}

