import SwiftUI

struct ProfileView: View {
    @State private var showEditProfile = false
    @StateObject var viewModel: UserProfileViewModel
    @State private var showUserRelationSheet = false
    let url = URL(string: "https://www.instagram.com/")!
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user))
    }
    
    private var isFollowed: Bool {
        return viewModel.user.isFollowed
    }
    
    private var user: User {
        return viewModel.user
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.firstName + user.lastName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.subheadline)
                        }
                        
                        if !user.phoneNumber.isEmpty {
                            Text(user.phoneNumber)
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                    
                    CircularProfileImageView(logoUrl: user.imageUrl, size: .medium)
                }
                HStack {
                    //Boton para compartir el perfil
                    ShareLink(item: url, label:
                                {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                            .frame(width: 35, height: 32)
                            .background(.black)
                            .cornerRadius(8)
                    })


                    //Boton para agregar y quitar de favoritos
                    Button {
                        print("Followed!")
                    } label: {
                        HStack{
                            Text(isFollowed ? "En Favoritos" : "Agregar a Favoritos")
                            Image(systemName: (isFollowed ? "heart.fill" : "heart" ))
                                .foregroundColor(isFollowed ? Color.red : Color.white)
                            
                        }
                        .foregroundColor(isFollowed ? Color.theme.primaryText : Color.theme.primaryBackground)
                        .frame(width: 320, height: 32)
                        .background(isFollowed ? Color.theme.primaryBackground : Color.theme.primaryText)
                        .cornerRadius(8)
                        .overlay {
                            if isFollowed {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                            
                        }
                    }
                }
                
                
                UserContentListView(viewModel: UserContentListViewModel(user: user))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
