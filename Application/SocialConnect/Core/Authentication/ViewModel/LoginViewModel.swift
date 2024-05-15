import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI
import JWTDecode

class LoginViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userFirstName") var userFirstName: String = ""
    @AppStorage("userLastName") var userLastName: String = ""
    @AppStorage("userPhoneNumber") var userPhoneNumber: String = ""
    @AppStorage("userRole") var userRole: String = ""
    @AppStorage("userImageUrl") var userImageUrl: String = ""
    @AppStorage("isOrganization") var isOrganization: Bool = false
    
    @Published var loginInfo: LoginInfo = LoginInfo(email: "", phone: "", password: "")
    @Published var isAuthenticating = false
    @Published var showAlert = false
    
    func login() {
        loginInfo.email = loginInfo.phone
        
        AF.request("\(mongoBaseUrl)/auth/login", method: .post, parameters: loginInfo, encoder: .json).response { response in
            switch response.result {
            case .success(let data):
                self.isAuthenticating = true
                
                if let responseData = data {
                    let json = try! JSON(data: responseData)
                    if json["token"].exists() {
                        self.token = json["token"].stringValue
                        let jwt = try! decode(jwt: self.token)
                        
                        if let sub = jwt.body["sub"] as? [String: Any] {
                            self.userRole = sub["role"] as! String
                            self.userId = sub["_id"] as! String
                            self.userEmail = sub["email"] as! String
                            self.userFirstName = sub["firstName"] as! String
                            self.userLastName = sub["lastName"] as! String
                            self.userPhoneNumber = sub["phoneNumber"] as! String
                            self.userImageUrl = sub["imageUrl"] as! String
                            self.isOrganization = sub["isOrganization"] as! Bool
                        }
                    } else {
                        self.showAlert = true
                    }
                }
                
                self.isAuthenticating = false
            case .failure(let err):
                self.isAuthenticating = true
                self.showAlert = true
                self.isAuthenticating = false
                print(err)
            }
        }
    }
}
