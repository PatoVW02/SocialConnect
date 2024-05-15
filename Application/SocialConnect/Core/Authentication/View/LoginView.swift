import SwiftUI
import Alamofire
import SwiftyJSON
import JWTDecode

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("Yconnect")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                
                VStack {
                    TextField("Ingresa tu teléfono", text: $viewModel.loginInfo.phone)
                        .autocapitalization(.none)
                        .modifier(ThreadsTextFieldModifier())
                    
                    SecureField("Ingresa tu contraseña", text: $viewModel.loginInfo.password)
                        .modifier(ThreadsTextFieldModifier())
                }
                
                Button {
                    Task { viewModel.login() }
                } label: {
                    Text(viewModel.isAuthenticating ? "" : "Login")
                        .foregroundColor(Color.theme.primaryBackground)
                        .modifier(PostsButtonModifier())
                        .overlay {
                            if viewModel.isAuthenticating {
                                ProgressView()
                                    .tint(Color.theme.primaryBackground)
                            }
                        }
                }
                .disabled(viewModel.isAuthenticating || viewModel.loginInfo.password.isEmpty || viewModel.loginInfo.phone.isEmpty)
                .opacity(viewModel.isAuthenticating || !viewModel.loginInfo.password.isEmpty || !viewModel.loginInfo.phone.isEmpty ? 1 : 0.7)
                .padding(.vertical)
                
                Spacer()
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.theme.primaryText)
                    .font(.footnote)
                }
                .padding(.vertical, 16)

            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text("Usuario o contraseña incorrecta"))
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
