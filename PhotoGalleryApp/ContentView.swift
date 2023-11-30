import SwiftUI
import PhotosUI
import Photos

struct ContentView: View {
    @State private var allPhotos = PHFetchResult<PHAsset>()
    @State private var photoThumbnailImages = [UIImage]()
    @State private var selectedImages = Set<UIImage>()
    @State private var folders = [PhotoFolder]()
    @State private var selectedFolder: PhotoFolder?
    @State private var isDeleteButtonVisible = false
    @State private var isFolderViewPresented = false
    @State private var pickerPresented = false
    @State private var isFullScreenViewPresented = false
    @State private var selectedFullScreenImageIndex: Int = 0
    @State private var fullScreenImages: [UIImage] = []

    let imageManager = PHCachingImageManager()
    
    private func deleteSelectedImages() {
        photoThumbnailImages.removeAll { selectedImages.contains($0) }
        for index in folders.indices {
            folders[index].photos.removeAll { selectedImages.contains($0) }
        }
        selectedImages.removeAll()
    }

    var body: some View {
        TabView{
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(photoThumbnailImages, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(6)
                                .padding(4)
                                .onTapGesture(count: 2) {
                                    selectedFullScreenImageIndex = photoThumbnailImages.firstIndex(of: img) ?? 0
                                           isFullScreenViewPresented = true
                                }
                                .onTapGesture(count: 1) {
                                    if selectedImages.contains(img) {
                                        selectedImages.remove(img)
                                    } else {
                                        selectedImages.insert(img)
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
                                .overlay(
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .opacity(selectedImages.contains(img) ? 1 : 0),
                                    alignment: .topLeading
                                )
                        }
                    }
                }
                .navigationTitle("Photos")
                .navigationBarItems(trailing: HStack {
                    Button("Add to Folder") {
                        isFolderViewPresented = true
                    }
                    .disabled(selectedImages.isEmpty)
                    Button(action: {
                        pickerPresented = true
                    }) {
                        Image(systemName: "plus")
                    }
                })
            }
            .sheet(isPresented: $isFolderViewPresented, onDismiss: {
                if let selectedFolderIndex = folders.firstIndex(where: { $0.id == selectedFolder?.id }) {
                    folders[selectedFolderIndex].photos.append(contentsOf: selectedImages)
                    selectedImages.removeAll()
                }
                selectedFolder = nil
            }) {
                FolderSelectionView(folders: $folders, selectedFolder: $selectedFolder)
            }
            .sheet(isPresented: $isFullScreenViewPresented) {
                FullscreenImageView(images: photoThumbnailImages, initialIndex: selectedFullScreenImageIndex)
            }
            .onChange(of: isFullScreenViewPresented) { _ in
                if isFullScreenViewPresented {
                    fullScreenImages = photoThumbnailImages
                    selectedFullScreenImageIndex = fullScreenImages.firstIndex(of: fullScreenImages[selectedFullScreenImageIndex]) ?? 0
                }
            }
            .sheet(isPresented: $pickerPresented, content: {
                ImagePicker(images: $photoThumbnailImages)
            })
            .tabItem {
                Image(systemName: "photo.on.rectangle.angled")
                Text("Gallery")
            }
            FolderView(folders: $folders, selectedFolder: $selectedFolder, photoThumbnailImages: $photoThumbnailImages)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Folders")
                }
        }
        
    }
}

struct PhotosPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
