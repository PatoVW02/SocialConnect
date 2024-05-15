//
//  OrganizationCell.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import SwiftUI

struct OrganizationCell: View {
    let organization: Organization
    let distance: Double? // Distancia en kilómetros
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                OrganizationCircularLogoImageView(logoUrl: organization.logoUrl, size: .small)
                
                VStack(alignment: .leading) {
                    Text(organization.name)
                        .bold()
                    if let distance = distance {
                        Text("Te queda a \(distance / 1000, specifier: "%.2f") km")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .font(.footnote)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.vertical, 4)
        .foregroundColor(Color.theme.primaryText)
    }
}

struct OrganizationCell_Previews: PreviewProvider {
    static var previews: some View {
        // Asegúrate de proporcionar un objeto de organización adecuado aquí para la vista previa
        OrganizationCell(organization: dev.organization, distance: 5.23)
    }
}
