import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON
import CoreLocation

@MainActor
class ExploreViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @Published var allOrganizations = [Organization]()
    @Published var recommendedOrganizations = [Organization]()
    @Published var selectedTab: SelectedExploreViewEnum = .recommendedOrganizations
    @Published var tags = [Tag]()
    @Published var distances: [String: Double] = [:]
    @Published private var locationManager = LocationManager()
    @Published var isLoading = false
    
    init() {
        Task { try fetchOrganizations(tags: nil, useUserTags: true) }
        Task { try fetchTags() }
    }
    
    func fetchOrganizations(tags: [String]?, useUserTags: Bool) throws {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        let recommendedOrganizationsParameters: [String: Any] = [
            "useUserTags": true
        ]
        
        let allOrganizationsParamaters: [String: Any] = [
            "useUserTags": false,
            "tags": tags ?? [""]
        ]
        
        AF.request("\(mongoBaseUrl)/organizations", method: .get, parameters: recommendedOrganizationsParameters, headers: HTTPHeaders(newHeaders)).responseData { data in
            self.recommendedOrganizations.removeAll()
            
            let json = try! JSON(data: data.data!)
            
            for organization in json {
                let socialNetworksArray: [Organization.SocialNetwork] = organization.1["socialNetworks"].arrayValue.map { socialNetworkObject in
                    let name = socialNetworkObject["name"].stringValue
                    let url = socialNetworkObject["url"].stringValue
                    return Organization.SocialNetwork(name: name, url: url)
                }
                
                let tagsArray: [String] = organization.1["tags"].arrayValue.map { value in
                    return value.stringValue
                }
                
                let org = Organization(
                    id: organization.1["_id"].stringValue,
                    userId: organization.1["userId"].stringValue,
                    name: organization.1["name"].stringValue,
                    userName: organization.1["userName"].stringValue,
                    rfc: organization.1["rfc"].stringValue,
                    schedule: organization.1["schedule"].stringValue,
                    address: Organization.Address(
                        street1: organization.1["address"]["street1"].stringValue,
                        street2: organization.1["address"]["street2"].stringValue,
                        city: organization.1["address"]["city"].stringValue,
                        state: organization.1["address"]["state"].stringValue,
                        zipCode: organization.1["address"]["zipCode"].stringValue,
                        country: organization.1["address"]["country"].stringValue
                    ),
                    contact: Organization.Contact(
                        phoneNumber: organization.1["contact"]["phoneNumber"].stringValue,
                        email: organization.1["contact"]["email"].stringValue
                    ),
                    description: organization.1["description"].stringValue,
                    socialNetworks: socialNetworksArray,
                    logoUrl: organization.1["logoUrl"].stringValue,
                    videoUrl: organization.1["videoUrl"].stringValue,
                    bannerUrl: organization.1["bannerUrl"].stringValue,
                    tags: tagsArray,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                self.geocodeAddress(org.address) { result in
                    switch result {
                    case .success(let location):
                        let distance = self.distanceFromUser(to: location)
                        if let distance = distance {
                            self.distances[org.id] = distance
                        }
                    case .failure(let error):
                        print("Error geocodificando: \(error)")
                    }
                }
                
                self.recommendedOrganizations.append(org)
            }
            
            self.recommendedOrganizations.sort { org1, org2 in
                let distance1 = self.distances[org1.id] ?? Double.infinity
                let distance2 = self.distances[org2.id] ?? Double.infinity
                return distance1 > distance2
            }
        }
        
        AF.request("\(mongoBaseUrl)/organizations", method: .get, parameters: allOrganizationsParamaters, headers: HTTPHeaders(newHeaders)).responseData { data in
            self.allOrganizations.removeAll()
            
            let json = try! JSON(data: data.data!)
            
            for organization in json {
                let socialNetworksArray: [Organization.SocialNetwork] = organization.1["socialNetworks"].arrayValue.map { socialNetworkObject in
                    let name = socialNetworkObject["name"].stringValue
                    let url = socialNetworkObject["url"].stringValue
                    return Organization.SocialNetwork(name: name, url: url)
                }
                
                let tagsArray: [String] = organization.1["tags"].arrayValue.map { value in
                    return value.stringValue
                }
                
                let org = Organization(
                    id: organization.1["_id"].stringValue,
                    userId: organization.1["userId"].stringValue,
                    name: organization.1["name"].stringValue,
                    userName: organization.1["userName"].stringValue,
                    rfc: organization.1["rfc"].stringValue,
                    schedule: organization.1["schedule"].stringValue,
                    address: Organization.Address(
                        street1: organization.1["address"]["street1"].stringValue,
                        street2: organization.1["address"]["street2"].stringValue,
                        city: organization.1["address"]["city"].stringValue,
                        state: organization.1["address"]["state"].stringValue,
                        zipCode: organization.1["address"]["zipCode"].stringValue,
                        country: organization.1["address"]["country"].stringValue
                    ),
                    contact: Organization.Contact(
                        phoneNumber: organization.1["contact"]["phoneNumber"].stringValue,
                        email: organization.1["contact"]["email"].stringValue
                    ),
                    description: organization.1["description"].stringValue,
                    socialNetworks: socialNetworksArray,
                    logoUrl: organization.1["logoUrl"].stringValue,
                    videoUrl: organization.1["videoUrl"].stringValue,
                    bannerUrl: organization.1["bannerUrl"].stringValue,
                    tags: tagsArray,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                self.geocodeAddress(org.address) { result in
                    switch result {
                    case .success(let location):
                        let distance = self.distanceFromUser(to: location)
                        if let distance = distance {
                            self.distances[org.id] = distance
                        }
                    case .failure(let error):
                        print("Error geocodificando: \(error)")
                    }
                }
                
                self.allOrganizations.append(org)
            }
            
            self.allOrganizations.sort { org1, org2 in
                let distance1 = self.distances[org1.id] ?? Double.infinity
                let distance2 = self.distances[org2.id] ?? Double.infinity
                return distance1 > distance2
            }
        }
    }
    
    func fetchTags() throws {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        AF.request("\(mongoBaseUrl)/tags", method: .get, headers: HTTPHeaders(newHeaders)).responseData { data in
            let json = try! JSON(data: data.data!)
            for tag in json {
                let newTag = Tag(
                    id: tag.1["_id"].stringValue,
                    name: tag.1["name"].stringValue,
                    description: tag.1["description"].stringValue,
                    createdAt: Date(),
                    updatedAt: Date(),
                    updatedBy: tag.1["updatedBy"].stringValue
                )

                self.tags.append(newTag)
            }
        }
    }
    
    func filteredOrganizations(_ query: String) -> [Organization] {
        let lowercasedQuery = query.lowercased()
        
        let organizationsToSearch: [Organization] = (selectedTab == .recommendedOrganizations) ? recommendedOrganizations : allOrganizations
        
        return organizationsToSearch.filter({
            $0.name.lowercased().contains(lowercasedQuery)
        })
    }
    
    private func geocodeAddress(_ address: Organization.Address, completion: @escaping (Result<CLLocation, Error>) -> Void) {
        let addressString = "\(address.street1) \(address.street2), \(address.city), \(address.state) \(address.zipCode), \(address.country)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(.success(location))
            }
        }
    }

    private func distanceFromUser(to location: CLLocation) -> Double? {
        guard let userLocation = locationManager.currentLocation else {
            return nil
        }
        return userLocation.distance(from: location) / 1000.0  // Convert to kilometers
    }
}
