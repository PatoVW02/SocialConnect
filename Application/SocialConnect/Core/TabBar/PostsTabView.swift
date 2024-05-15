import SwiftUI

struct PostsTabView: View {
    @AppStorage("isOrganization") var isOrganization: Bool = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .imageScale(.large)
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)

            ExploreView()
                .tabItem { Image(systemName: "magnifyingglass")
                    .imageScale(.large)}
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            if isOrganization {
                CreatePostDummyView(tabIndex: $selectedTab)
                    .tabItem { Image(systemName: selectedTab == 2 ? "plus.app.fill" : "plus.app")
                            .imageScale(.large)
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                    }
                    .onAppear { selectedTab = 2 }
                    .tag(2)
            }

            FavoriteView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "star.fill" : "star")
                    .imageScale(.large)
                    .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)

            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .imageScale(.large)
                    .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
        }
        .tint(Color.theme.primaryText)
    }
}

struct PostsTabView_Previews: PreviewProvider {
    static var previews: some View {
        PostsTabView()
    }
}
