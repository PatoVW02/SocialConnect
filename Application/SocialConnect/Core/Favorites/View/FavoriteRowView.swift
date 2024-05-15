import SwiftUI

struct FavoriteRowView: View {
    let favorite: Favorite
    @ObservedObject var viewModel: FavoriteViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NavigationLink(value: favorite.organizationId) {
                        ZStack(alignment: .bottomTrailing) {
                            OrganizationCircularLogoImageView(logoUrl: favorite.logoUrl, size: .large)
                                .navigationDestination(for: Organization.self) { organization in
                                    OrganizationProfileView(organization: organization)
                                }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            VStack {
                                Text(favorite.name)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color.theme.primaryText)

                                Text(favorite.description ?? "No description for this organization")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Button {
                                viewModel.removeFavorite(favoriteId: favorite.id)
                            } label: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            .padding()
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

struct FavoriteRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRowView(favorite: dev.favorite, viewModel: FavoriteViewModel())
    }
}
