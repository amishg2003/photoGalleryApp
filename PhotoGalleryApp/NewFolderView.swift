import SwiftUI
import PhotosUI
import Photos

struct NewFolderView: View {
    @Binding var folders: [PhotoFolder]
    @Environment(\.presentationMode) var presentationMode
    @State private var newFolderName: String = ""
    var body: some View {
        NavigationView {
            Form {
                TextField("Folder Name", text: $newFolderName)
                Button("Create") {
                    let newFolder = PhotoFolder(name: newFolderName)
                    folders.append(newFolder)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(newFolderName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .navigationBarTitle("New Folder", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
