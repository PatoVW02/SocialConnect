import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel = FavoriteViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.favorites) { favorite in
                            HStack {
                                FavoriteRowView(favorite: favorite, viewModel: viewModel)
                            }
                            Divider()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchFavorites()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task { viewModel.fetchFavorites() }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(Color.theme.primaryText)
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Favoritos")
            .background(Background())
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
