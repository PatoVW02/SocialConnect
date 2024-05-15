import SwiftUI

struct SettingsView: View {
    @AppStorage("token") var token: String = ""
    @AppStorage("userId") var userId: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userFirstName") var userFirstName: String = ""
    @AppStorage("userLastName") var userLastName: String = ""
    @AppStorage("userPhoneNumber") var userPhoneNumber: String = ""
    @AppStorage("userRole") var userRole: String = ""
    @AppStorage("userImageUrl") var userImageUrl: String = ""
    @AppStorage("isOrganization") var isOrganization: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(SettingsOptions.allCases) { option in
                HStack {
                    Image(systemName: option.imageName)
                    
                    Text(option.title)
                        .font(.subheadline)
                }
            }
            
            VStack(alignment: .leading) {
                Divider()
                
                Button("Cerrar Sesión") {
                    token = ""
                    userId = ""
                    userEmail = ""
                    userFirstName = ""
                    userLastName = ""
                    userPhoneNumber = ""
                    userRole = ""
                    userImageUrl = ""
                    isOrganization = false
                }
                .font(.subheadline)
                .listRowSeparator(.hidden)
                .padding(.top)

            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
