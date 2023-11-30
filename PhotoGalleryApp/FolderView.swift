import SwiftUI
import PhotosUI
import Photos

struct FolderView: View {
    @Binding var folders: [PhotoFolder]
    @Binding var selectedFolder: PhotoFolder?
    @Binding var photoThumbnailImages: [UIImage]
    
    @State private var showingPhotoGridSheet = false
    @State private var showingNewFolderView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: "plus")
                                           .font(.system(size: 30))
                                           .foregroundColor(.white)
                                           .frame(width: 100, height: 100)
                                           .background(Rectangle().fill(Color.gray))
                            .onTapGesture {
                                showingNewFolderView = true
                                folders = folders.map { $0 }
                            }
                        Text("Create Folder")
                            .foregroundColor(.blue)
                        Text("")
                    }
                    .onTapGesture {
                        showingNewFolderView = true
                    }
                    ForEach(folders, id: \.id) { folder in
                        VStack {
                            folder.photos.first.map {
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(6)
                                    .padding(4)
                            }
                            if folder.photos.isEmpty {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                            }
                            VStack {
                                Text("\(folder.name)")
                                    .font(.headline)
                                    .fontWeight(.bold) // Make the folder name bold
                                Text("\(folder.photos.count) items")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            folders = folders.map { $0 }
                            self.selectedFolder = folder
                            self.showingPhotoGridSheet = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Folders")
            .sheet(isPresented: $showingNewFolderView) {
                NewFolderView(folders: $folders)
            }
            .sheet(isPresented: $showingPhotoGridSheet) {
                if let index = folders.firstIndex(where: { $0.id == selectedFolder?.id }) {
                    PhotoGridView(photos: $folders[index].photos, onDelete: { deletedThumbnails in
                        photoThumbnailImages.removeAll { deletedThumbnails.contains($0) }
                    }, thumbnailImages: $photoThumbnailImages)                  .onAppear{
                            folders[index].photos = folders[index].photos.map{ $0}
                        }
                    
                }
            }
        }
    }
}

