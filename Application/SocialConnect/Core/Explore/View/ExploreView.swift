import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    OrganizationListView(viewModel: viewModel)
                        .navigationDestination(for: Organization.self) { organization in
                            OrganizationProfileView(organization: organization)
                        }
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .background(Background())
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
