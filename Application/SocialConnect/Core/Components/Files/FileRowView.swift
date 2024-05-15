//
//  FileRowView.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 11/10/23.
//

import SwiftUI

struct FileRowView: View {
    var file: OrganizationFiles
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100) // Adjust as needed
            }
            HStack {
                Text(file.name)
                    .font(.body)
                Spacer()
                Text("\(file.size / 1024) KB")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        if let imageData = Data(base64Encoded: file.content) {
            uiImage = UIImage(data: imageData)
        }
    }
}

#Preview {
    FileRowView(file: OrganizationFiles(id: "652643201bf752ea25e2fb06", organizationId: "65263562d45fed8455675e63", name: "Imagen 2 paz es.jpg", content: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wAAAzAB/o1Z5QAAAABJRU5ErkJggg==", size: 1501819, type: "image/jpeg", createdAt: Date.now))
}
