import SwiftUI
import Kingfisher

enum CurrentUserProfileSheetConfig: Identifiable {
    case editProfile
    
    var id: Int { return hashValue }
}

struct CurrentUserProfileContentView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var sheetConfig: CurrentUserProfileSheetConfig?
    @State private var imageLoadSuccess: Bool? = nil
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.trailing)
                }
                .padding(.all)
                
                VStack(alignment: .leading) {
                    profileHeaderView()
                        .padding([.horizontal, .top])

                    actionButtonsView()

                    userInfoView()

                    Divider()
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Background())
        .sheet(item: $sheetConfig, content: { config in
            switch config {
            case .editProfile:
                EditProfileView()
                    .environmentObject(viewModel)
            }
        })
    }
    
    private func profileHeaderView() -> some View {
        HStack {
            if viewModel.userImageUrl.isEmpty || imageLoadSuccess == false {
                Color.gray
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 115)
                    .padding(.leading, 5)
            } else {
                KFImage(URL(string: viewModel.userImageUrl))
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        KingfisherManager.shared.retrieveImage(with: URL(string: viewModel.userImageUrl)!) { result in
                            switch result {
                            case .success(_):
                                imageLoadSuccess = true
                            case .failure(_):
                                imageLoadSuccess = false
                            }
                        }
                    }
                    .clipShape(Circle())
                    .frame(width: 115)
                    .padding(.leading, 5)
            }
            
            Spacer()

            VStack(alignment: .trailing) {
                Text("\(viewModel.userFirstName) \(viewModel.userLastName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryText"))
                    .lineLimit(nil)
            }
            .padding(.all, 0)
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.4))
        .cornerRadius(8)
    }
    
    private func actionButtonsView() -> some View {
        HStack {
            Button(action: {
                sheetConfig = .editProfile
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Modificar perfil")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 175, height: 32)
                .foregroundColor(.white)
                .background(Color.cyan)
                .cornerRadius(10)
            }
            
            Button(action: {
            }) {
                ShareLink(item: "https://www.socialconnect.com/user/\(viewModel.userId)", label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Compartir Perfil")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 175, height: 32)
                    .foregroundColor(.white)
                    .background(Color.cyan)
                    .cornerRadius(10)
                })
            }
        }
        .padding()
    }
    
    private func userInfoView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if !viewModel.userEmail.isEmpty {
                Label("Correo: \(viewModel.userEmail)", systemImage: "mail.fill")
                    .foregroundColor(Color("PrimaryText"))
            }
            
            if !viewModel.userPhoneNumber.isEmpty {
                Label("Teléfono: \(viewModel.userPhoneNumber)", systemImage: "phone.fill")
                    .foregroundColor(Color("PrimaryText"))
            }

            if !viewModel.userRole.isEmpty {
                Label("Rol: \(viewModel.userRole)", systemImage: "person.fill")
                    .foregroundColor(Color("PrimaryText"))
            }

            Label("Organización: \(viewModel.isOrganization ? "Si" : "No")", systemImage: "building.2.fill")
                .foregroundColor(Color("PrimaryText"))
        }
        .padding(.horizontal)
    }
}

struct CurrentUserProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileContentView()
    }
}
