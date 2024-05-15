import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON

// Definición de la vista RegistrationView
struct RegistrationView: View {
    @AppStorage("token") var token: String = ""
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedTags: Set<Tag> = []
    @State var selectedTagIDs: [String] = []
    @State var rePassword: String = ""
    @State var shouldShowLoginView = false
    
    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            Image("Yconnect")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            // Se crean campos de texto para el ingreso de información de registro
            VStack {
                NavigationLink{
                    OrganizationRegistrationView()
                } label: {
                    Text("Registrarse como Organización")
                        .foregroundColor(Color.theme.primaryBackground)
                        .modifier(PostsButtonModifier())
                }
                
                TextField("Ingrese su numero de telefono", text: $viewModel.phonenumber)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
                
                SecureField("Ingrese su password", text: $viewModel.password)
                    .modifier(ThreadsTextFieldModifier())
                SecureField("Reingrese su password", text: $rePassword)
                    .modifier(ThreadsTextFieldModifier())
                
                HStack{
                    Text("Seleccionar Tags de Interés")
                        .padding(.leading, 30)
                        .font(.title2)
                    Spacer()
                }
    
                ScrollView(.horizontal){
                    HStack{
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
                }
                .padding(10)
            }
            
            // Botón para enviar la información de registro
            Button {
                if formIsValid {
                    for tag in selectedTags{
                                        selectedTagIDs.append(tag.id)
                                    }
                        createUser()
                    dismiss()
                    } else {
                        // If the form is not valid, show an alert
                        viewModel.showAlert = true
                    }
            } label: {
                Text(viewModel.isAuthenticating ? "" : "Sign up")
                    .foregroundColor(Color.theme.primaryBackground)
                    .modifier(PostsButtonModifier())
                    .overlay {
                        if viewModel.isAuthenticating {
                            ProgressView()
                                .tint(Color.theme.primaryBackground)
                        }
                    }
                    
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            // Botón para redirigir al usuario a la pantalla de inicio de sesión
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.primaryText)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
                }
        .alert(isPresented: $viewModel.showAlert) {
            // Se muestra una alerta en caso de error de autenticación
            Alert(title: Text("Error"),
                  message: Text("Asegurate de llenar los campos correctamente."))
        }
    }
    
    func createUser() {
        var newHeaders = HTTPHeaders(mongoHeaders)
            newHeaders.add(name: "Authorization", value: "Bearer \(token)")
        
        let parameters: [String: Any] = [
            "firstName": "",
            "lastName": "",
            "phoneNumber": viewModel.phonenumber,
            "email": "",
            "password": viewModel.password,
            "tags": selectedTagIDs,
            "role": "6510eb0613e234b63bde168d",
            "imageUrl": ""
        ]
        
        AF.request("\(mongoBaseUrl)/users", method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: newHeaders).responseData { response in
             switch response.result {
             case .success(let value):
                 print(value)
                 shouldShowLoginView = true
                 
             case .failure(let error):
                 print(error)
             }
         }
    }
}

// MARK: - Validación del formulario

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        // La validación del formulario verifica que los campos no estén vacíos y que el campo de correo electrónico contenga un "@" y que la contraseña sea lo suficientemente larga.
        return !viewModel.phonenumber.isEmpty
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
        && viewModel.password == rePassword
        && viewModel.phonenumber.allSatisfy { $0.isNumber }
    }
}

// Vista previa de RegistrationView
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
