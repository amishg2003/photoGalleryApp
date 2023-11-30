import SwiftUI
import PhotosUI
import Photos

struct FullscreenImageView: View {
    let images: [UIImage]
    @State private var currentIndex: Int
    init(images: [UIImage], initialIndex: Int) {
        self.images = images
        self._currentIndex = State(initialValue: initialIndex)
    }
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(uiImage: images[index])
                    .resizable()
                    .scaledToFit()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black)
        .ignoresSafeArea()
    }
}
