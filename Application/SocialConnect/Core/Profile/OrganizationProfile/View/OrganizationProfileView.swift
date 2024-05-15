//
//  OrganizationProfileView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import SwiftUI
import Kingfisher

struct OrganizationProfileView: View {
    @StateObject var viewModel: OrganizationProfileViewModel
    @State private var showUserRelationSheet = false
    @State private var imageLoadSuccess: Bool? = nil
    @State var bannerRetrieved = true

    let url = URL(string: "https://www.instagram.com/")!

    init(organization: Organization) {
        self._viewModel = StateObject(wrappedValue: OrganizationProfileViewModel(organization: organization))
    }

    private var organization: Organization {
        return viewModel.organization
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        if organization.bannerUrl.isEmpty || imageLoadSuccess == false {
                            Color.gray
                        } else {
                            KFImage(URL(string: organization.bannerUrl))
                                .resizable()
                                .scaledToFill()
                                .onAppear {
                                    KingfisherManager.shared.retrieveImage(with: URL(string: organization.bannerUrl)!) { result in
                                        switch result {
                                        case .success(_):
                                            imageLoadSuccess = true
                                        case .failure(_):
                                            imageLoadSuccess = false
                                        }
                                    }
                                }
                        }
                    }

                    VStack {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(organization.name)
                                        .font(.title)
                                        .fontWeight(.semibold)

                                    if let desc = organization.description {
                                        Text(desc)
                                            .font(.subheadline)
                                    }
                                }

                                Spacer()

                                OrganizationCircularLogoImageView(logoUrl: organization.logoUrl, size: .large)
                            }

                            Spacer()

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Registrada en \(DateFormatter.organizationDateFormatter.string(from: organization.createdAt))")
                                        .font(.footnote)
                                    
                                    Text("Actualizada en \(DateFormatter.organizationDateFormatter.string(from: organization.createdAt))")
                                        .font(.footnote)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    // Sharing button
                                    ShareLink(item: "https://www.socialconnect.com/organization/\(viewModel.organization.id)", label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.white)
                                            .frame(width: 35, height: 32)
                                            .background(.black)
                                            .cornerRadius(8)
                                    })

                                    // Favorite star button
                                    Button {
                                        if !viewModel.starClicked {
                                            viewModel.markAsFavorite(organizationId: organization.id)
                                        } else {
                                            viewModel.unmarkAsFavorite()
                                        }
                                    } label: {
                                        ZStack{
                                            Color.black
                                                .frame(width: 35, height: 32)
                                                .cornerRadius(8)

                                            Image(systemName: viewModel.starClicked ? "star.fill" : "star")
                                                .foregroundColor(viewModel.starClicked ? .yellow : .white)
                                                .frame(width: 33, height: 30)
                                                .background(viewModel.starClicked ? .white : .black)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                                .padding(.top)
                        }
                        .padding([.leading, .top, .bottom, .trailing])
                        
                        Spacer()
                        OrganizationInformationCardView(organization: viewModel.organization)
                        
                        VStack {
                            Text("Redes Sociales")
                                .font(.title2)
                                .bold()
                            // Social Networks
                            HStack(spacing: 10) {
                                ForEach(organization.socialNetworks, id: \.name) { network in
                                    Link(destination: URL(string: network.url)!) {
                                        Text(network.name)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        Divider()
                            .padding(.top)

                        VStack(alignment: .leading) {
                            VStack {
                                Text("Publicaciones")
                                    .font(.title)
                                    .bold()
                            }
                            
                            VStack {
                                if viewModel.posts.count > 0 {
                                    ForEach(viewModel.posts, id: \.id) { post in
                                        VStack {
                                            OrganizationPostView(post: post)
                                        }
                                    }
                                } else {
                                    Text("No hay publicaciones")
                                }
                            }
                            .padding(.top, 2)
                        }

                        Spacer()
                        
                        Text("\n")
                    }
                    .padding(.horizontal)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .background(Background())
        }
    }

    func getBannerHeight(geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        let height: CGFloat = geometry.size.height / 4
        let bannerHeight = height - offset / 4  // Adjust this calculation as needed to control the shrinking effect
        return max(bannerHeight, height / 2)    // This ensures banner doesn't get too small
    }
}

struct OrganizationProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationProfileView(organization: dev.organization)
    }
}
