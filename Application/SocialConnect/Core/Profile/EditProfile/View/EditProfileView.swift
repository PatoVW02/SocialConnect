import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    @State private var isPrivateProfile = false
    @State private var selectedTags: Set<Tag> = []
    
    private var user: User? {
        return viewModel.currentUser
    }
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                VStack(alignment: .leading){
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Nombre")
                                .fontWeight(.semibold)
                            
                            Text(viewModel.userFirstName + " " + viewModel.userLastName)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Tags de Interes ")
                            .fontWeight(.semibold)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    TagView(tag: tag, isSelected: selectedTags.contains(tag))
                                        .onTapGesture {
                                            var newSelectedTags = selectedTags
                                            if newSelectedTags.contains(tag) {
                                                newSelectedTags.remove(tag)
                                            } else {
                                                newSelectedTags.insert(tag)
                                            }
                                            selectedTags = newSelectedTags
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .id(UUID())
                    }
                    .font(.footnote)
                }
                
                .navigationTitle("Editar Perfil")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(Color.theme.primaryText)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Listo") {
                            Task {
                                await updateUserProfile()
                                dismiss()
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .background(Color.theme.primaryBackground)
            }
            .onAppear {
                if !viewModel.currentUserTags.isEmpty {
                    selectedTags = Set(viewModel.currentUserTags)
                } else {
                    selectedTags = Set(viewModel.tags)
                }
            }
            .onReceive(viewModel.$currentUserTags) { newTags in
                selectedTags = Set(newTags)
            }
        }
    }
    
    func updateUserProfile() async {
        viewModel.updateUserProfile(newTags: Array(selectedTags))
    }
    
    func calculateFit(in width: CGFloat) -> Int {
        let tagWidth: CGFloat = 100 // Replace with your calculated or average tag width
        let padding: CGFloat = 20 // The total horizontal padding used in the VStack

        let totalWidth = width - padding
        return max(1, Int(totalWidth / tagWidth)) // At least one tag should be shown
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = CurrentUserProfileViewModel()

        EditProfileView().environmentObject(mockViewModel)
    }
}
