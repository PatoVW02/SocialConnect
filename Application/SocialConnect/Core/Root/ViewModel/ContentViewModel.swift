//
//  ContentViewModel.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 13/10/23.
//

import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    
    func isValidJWT() -> Bool {
        return self.token.split(separator: ".").count == 3
    }
}
