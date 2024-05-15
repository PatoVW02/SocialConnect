import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text((user?.firstName ?? "") + (user?.lastName ?? ""))
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user?.email ?? "")
                }
                
                if let phoneNumber = user?.phoneNumber {
                    Text(phoneNumber)
                        .font(.footnote)
                }
                
                Text("22k followers")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            CircularProfileImageView(logoUrl: user?.imageUrl, size: .medium)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
    }
}
