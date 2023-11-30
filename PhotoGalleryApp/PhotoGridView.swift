import SwiftUI
import PhotosUI
import Photos

struct PhotoGridView: View {
    @Binding var photos: [UIImage]
    @State private var selectedImages: Set<UIImage> = []
    @State private var isDeleteButtonVisible = false
    @Environment(\.presentationMode) var presentationMode

    var onDelete: (([UIImage]) -> Void)?
    @Binding var thumbnailImages: [UIImage]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(photos, id: \.self) { img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(6)
                            .padding(4)
                            .overlay(
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .opacity(selectedImages.contains(img) ? 1 : 0),
                                alignment: .topLeading
                            )
                            .onTapGesture {
                                toggleSelection(for: img)
                            }
                    }
                }
            }
            .onLongPressGesture {
                isDeleteButtonVisible = true
            }
            .contextMenu {
                if isDeleteButtonVisible {
                    Button("Delete Selected") {
                        deleteSelectedImages()
                    }
                }
            }
            Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
        }
    }

    private func toggleSelection(for image: UIImage) {
        if selectedImages.contains(image) {
            selectedImages.remove(image)
        } else {
            selectedImages.insert(image)
        }
    }

    private func deleteSelectedImages() {
        photos.removeAll { selectedImages.contains($0) }
        photos = photos.filter { !selectedImages.contains($0) }
        onDelete?(selectedImages.map { $0 })
        selectedImages.removeAll()
    }
}
