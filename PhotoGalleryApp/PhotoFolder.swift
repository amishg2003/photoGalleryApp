import SwiftUI
import PhotosUI
import Photos

struct PhotoFolder: Identifiable {
    let id: UUID = UUID()
    var name: String
    var photos: [UIImage] = []
    
    static func == (lhs: PhotoFolder, rhs: PhotoFolder) -> Bool {
        lhs.id == rhs.id
    }
}
