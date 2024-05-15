import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CreatePostViewModel()
    @Binding var tabIndex: Int

    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Titulo de publicación...", text: $viewModel.title, axis: .vertical)

                        TextField("URL del video de YouTube", text: $viewModel.fileUrl)
                            .font(.footnote)

                        if !viewModel.fileUrl.isEmpty {
                            WebView(urlString: viewModel.fileUrl)
                                .frame(height: 200)
                        }

                        TextField("Descripción de publicación", text: $viewModel.content)
                            .font(.footnote)
                    }
                    .font(.footnote)

                    Spacer()

                    if !viewModel.content.isEmpty {
                        Button {
                            viewModel.content = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.primaryText)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            try await viewModel.createPost()
                            dismiss()
                        }
                    } label: {
                        Label("Publicar", systemImage: "paperplane.fill")
                    }
                    .opacity(viewModel.title.isEmpty ? 0.5 : 1.0)
                    .disabled(viewModel.title.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.theme.primaryText)
                }
            }
            .onDisappear { tabIndex = 0 }
            .navigationTitle("Nueva publicacion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(tabIndex: .constant(0))
    }
}
