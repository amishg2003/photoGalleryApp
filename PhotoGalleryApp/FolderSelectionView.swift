import SwiftUI
import PhotosUI
import Photos

struct FolderSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var folders: [PhotoFolder]
    @Binding var selectedFolder: PhotoFolder?
    @State private var selectedImagesToAdd: Set<UIImage> = Set()
    @State private var photosChanged = false

    var body: some View {
        NavigationView {
            List(folders) { folder in
                HStack {
                    Text(folder.name)
                    Spacer()
                    if selectedFolder?.id == folder.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .onTapGesture {
                    selectedFolder = folder
                }
            }
            .navigationTitle("Select Folder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let folder = selectedFolder {
                            if let index = folders.firstIndex(where: { $0.id == folder.id }) {
                                folders[index].photos.append(contentsOf: selectedImagesToAdd)
                                
                                photosChanged.toggle()
                                
                                selectedImagesToAdd.removeAll()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }}
            }
        }
    }
}
