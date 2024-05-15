//
//  BannerView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 11/10/23.
//

import SwiftUI

struct BannerViewPlaceHolder: View {
    @Binding var bannerRetrieved: Bool

    var body: some View {
        Group {
            if bannerRetrieved {
                Color.clear
            } else {
                Color.gray
            }
        }
    }
}

#Preview {
    BannerViewPlaceHolder(bannerRetrieved: .constant(true))
}
