//
//  OrganizationListView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import SwiftUI

struct OrganizationListView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedTags: Set<Tag> = []
    
    var organizations: [Organization] {
        if searchText.isEmpty {
            switch viewModel.selectedTab {
            case .recommendedOrganizations:
                return viewModel.recommendedOrganizations
            case .allOrganizations:
                return viewModel.allOrganizations
            }
        } else {
            return viewModel.filteredOrganizations(searchText)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    TextField("Buscar", text: $searchText)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .frame(maxWidth: isSearching ? geometry.size.width * 0.7 : geometry.size.width * 0.85)
                        .onTapGesture {
                            isSearching = true
                        }
                    
                    Spacer()
                    
                    if isSearching {
                        Button("Cancelar") {
                            searchText = ""
                            isSearching = false
                            selectedTags.removeAll()
                            Task { try viewModel.fetchOrganizations(tags: nil, useUserTags: true) }
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 50)
                
                if isSearching {
                    Text("Filtro por Tags")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                TagView(tag: tag, isSelected: selectedTags.contains(tag))
                                    .onTapGesture {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    Button {
                        viewModel.selectedTab = .allOrganizations
                    } label: {
                        Text("Todas")
                            .padding(.all, 10)
                            .background(viewModel.selectedTab == .allOrganizations ? Color.blue : Color.white.opacity(0.4))
                            .foregroundColor(viewModel.selectedTab == .allOrganizations ? .white : .black)
                            .cornerRadius(5)
                    }
                    
                    Spacer().frame(width: 20)
                    
                    Divider()
                        .frame(height: 40)
                    
                    Spacer().frame(width: 20)
                    
                    Button {
                        viewModel.selectedTab = .recommendedOrganizations
                    } label : {
                        Text("Recomendaciones")
                            .padding(.all, 10)
                            .background(viewModel.selectedTab == .recommendedOrganizations ? Color.blue : Color.white.opacity(0.4))
                            .foregroundColor(viewModel.selectedTab == .recommendedOrganizations ? .white : .black)
                            .cornerRadius(5)
                    }
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(organizations) { organization in
                            let distance = viewModel.distances[organization.id]
                            NavigationLink(value: organization) {
                                OrganizationCell(organization: organization, distance: distance)
                                    .padding(.leading)
                            }
                        }
                        
                    }
                    .navigationTitle("Búsqueda")
                    .padding(.top)
                }
            }
            .navigationTitle("Search")
            .onChange(of: selectedTags) { _ in
                let tagIds = selectedTags.map { tag in
                    return tag.id
                }
                
                Task { try viewModel.fetchOrganizations(tags: tagIds, useUserTags: false) }
            }
            .background(Background())
        }
    }
}

struct OrganizationListView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationListView(viewModel: ExploreViewModel())
    }
}
