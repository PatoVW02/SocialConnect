//
//  Background.swift
//  SocialConnect
//
//  Created by Alumno on 10/10/23.
//

import SwiftUI

struct Background: View {
    var body: some View {
        Image("Fondo(s)")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
