import SwiftUI

struct CurrentUserProfileView: View {
    private var didNavigate: Bool? = false
    
    @AppStorage("userId") var userId: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userFirstName") var userFirstName: String = ""
    @AppStorage("userLastName") var userLastName: String = ""
    @AppStorage("userPhoneNumber") var userPhoneNumber: String = ""
    @AppStorage("userRole") var userRole: String = ""
    @AppStorage("userImageUrl") var userImageUrl: String = ""
    @AppStorage("isOrganization") var isOrganization: Bool = false
    
    init(didNavigate: Bool? = false) {
        self.didNavigate = didNavigate
    }

    var body: some View {
        Group {
            if let didNavigate, didNavigate == true {
                VStack {
                    CurrentUserProfileContentView()
                        .padding()
                }
            } else {
                NavigationStack {
                    CurrentUserProfileContentView()
                }
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView()
    }
}
