//
//  OrganizationRegistrationView.swift
//  SocialConnect
//
//  Created by David Faudoa on 09/10/23.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct OrganizationRegistrationView: View {
    
    @AppStorage("token") var token: String = ""
    @StateObject var viewModel = RegistrationViewModel()
    @State var registerOrgInfo: RegisterOrgInfo = RegisterOrgInfo(name: "", userName: "", rfc: "", schedule: "", phoneNumber: "", email: "", desc: "", logourl: "", street: "", number: "", city: "", state: "", zipcode: "", country: "", Tags: [], password: "", facebook: "", instagram: "", twitter: "")
    
    @State var isAuthenticating: Bool = false
    @State var showAlert: Bool = false
    @State private var selectedTags: Set<Tag> = []
    @State var selectedTagIDs: [String] = []
    
    
    var body: some View {
        ScrollView{
            VStack{
                Image("Yconnect")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                
                HStack{
                    Text("Información de Perfil")
                        .font(.title2)
                        .padding(.leading, 30)
                    Spacer()
                }
                
                TextField("Nombre de Organización", text: $registerOrgInfo.name)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Nombre de Usuario", text: $registerOrgInfo.userName)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Contraseña", text: $registerOrgInfo.password)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("RFC", text: $registerOrgInfo.rfc)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Descripción", text: $registerOrgInfo.desc)
                    .modifier(ThreadsTextFieldModifier())
                TextField("URL del logo", text: $registerOrgInfo.logourl)
                    .modifier(ThreadsTextFieldModifier())
                
                HStack{
                    Text("Información de Contacto")
                        .font(.title2)
                        .padding(.leading, 30)
                    Spacer()
                }
                TextField("Correo Electrónico", text: $registerOrgInfo.email)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Numero de Teléfono", text: $registerOrgInfo.phoneNumber)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Horario de Atención", text: $registerOrgInfo.schedule)
                    .modifier(ThreadsTextFieldModifier())
                
                HStack{
                    Text("Link a Redes Sociales")
                        .font(.title2)
                        .padding(.leading, 30)
                    Spacer()
                }
                
                TextField("Facebook", text: $registerOrgInfo.facebook)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Instagram", text: $registerOrgInfo.instagram)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Twitter", text: $registerOrgInfo.twitter)
                    .modifier(ThreadsTextFieldModifier())
                
                HStack{
                    Text("Dirección")
                        .font(.title2)
                        .padding(.leading, 30)
                    Spacer()
                }
                
                HStack(spacing: -40){
                    TextField("Calle", text: $registerOrgInfo.street)
                        .modifier(ThreadsTextFieldModifier())
                        .padding(0)
                        .frame(width: 260)
                    
                    TextField("Numero", text: $registerOrgInfo.number)
                        .modifier(ThreadsTextFieldModifier())
                        .padding(0)
                    
                }
                HStack(spacing: -40){
                    TextField("Ciudad", text: $registerOrgInfo.city)
                        .modifier(ThreadsTextFieldModifier())
                    TextField("Estado", text: $registerOrgInfo.state)
                        .modifier(ThreadsTextFieldModifier())
                }
                
                HStack(spacing: -40){
                    TextField("Codigo Postal", text: $registerOrgInfo.zipcode)
                        .modifier(ThreadsTextFieldModifier())
                    
                    TextField("País", text: $registerOrgInfo.country)
                        .modifier(ThreadsTextFieldModifier())
                }
                
                HStack{
                    Text("Tags")
                        .font(.title2)
                        .padding(.leading, 30)
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
                
                Button{
                    for tag in selectedTags{
                        selectedTagIDs.append(tag.id)
                    }
                    registerOrg()
                } label: {
                    Text("Sign up")
                        .foregroundColor(Color.theme.primaryBackground)
                        .modifier(PostsButtonModifier())
                }
                .disabled(
                    registerOrgInfo.name.isEmpty ||
                    registerOrgInfo.userName.isEmpty ||
                    registerOrgInfo.password.isEmpty ||
                    registerOrgInfo.rfc.isEmpty ||
                    registerOrgInfo.desc.isEmpty ||
                    registerOrgInfo.logourl.isEmpty ||
                    registerOrgInfo.email.isEmpty ||
                    registerOrgInfo.phoneNumber.isEmpty ||
                    registerOrgInfo.schedule.isEmpty ||
                    registerOrgInfo.street.isEmpty ||
                    registerOrgInfo.number.isEmpty ||
                    registerOrgInfo.city.isEmpty ||
                    registerOrgInfo.state.isEmpty ||
                    registerOrgInfo.zipcode.isEmpty ||
                    registerOrgInfo.country.isEmpty
                )
                .alert(isPresented: $showAlert) {
                            Alert(title: Text("Exito!"), message: Text("Organización creada con éxito"), dismissButton: .default(Text("OK")))
                        }
                
            }
        }
    }
    func registerOrg() {
        var newHeaders = HTTPHeaders(mongoHeaders)
            newHeaders.add(name: "Authorization", value: "Bearer \(token)")
        
        let parameters: [String: Any] = [
            "name": registerOrgInfo.name,
            "userName": registerOrgInfo.userName,
            "description": registerOrgInfo.desc,
            "password": registerOrgInfo.password,
            "logoUrl": registerOrgInfo.logourl,
            "videoUrl": "",
            "bannerUrl": "",
            "rfc": registerOrgInfo.rfc,
            "schedule": registerOrgInfo.schedule,
            "address": [
                "street1": registerOrgInfo.street,
                "street2": registerOrgInfo.number,
                "city": registerOrgInfo.city,
                "state": registerOrgInfo.state,
                "zipCode": registerOrgInfo.zipcode,
                "country": registerOrgInfo.country
            ],
            "contact": [
                "email": registerOrgInfo.email,
                "phoneNumber": registerOrgInfo.phoneNumber
            ],
            "socialNetworks": [
                [
                    "name": "Facebook",
                    "url": registerOrgInfo.facebook
                ],
                [
                    "name": "Twitter",
                    "url": registerOrgInfo.twitter
                ],
                [
                    "name": "Instagram",
                    "url": registerOrgInfo.instagram
                ]
            ],
            "role": "6510eb0613e234b63bde168d",
            "tags": selectedTagIDs
        ]
        
        AF.request("\(mongoBaseUrl)/organizations", method: .post, parameters: parameters,  encoding: JSONEncoding.default, headers: newHeaders).responseData { response in
             switch response.result {
             case .success(let value):
                 print(value)
                 showAlert = true
             case .failure(let error):
                 print(error)
             }
         }
    }

}

#Preview {
    OrganizationRegistrationView()
}
