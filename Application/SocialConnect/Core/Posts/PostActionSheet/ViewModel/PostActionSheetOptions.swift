//
//  PostActionSheetOptions.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 05/10/23.
//

import Foundation

enum PostActionSheetOptions {
    case unfavorite
    case hide
    case report
    
    var title: String {
        switch self {
        case .unfavorite:
            return "Unfollow"
        case .hide:
            return "Mute"
        case .report:
            return "Hide"
        }
    }
}
