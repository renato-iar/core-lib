public protocol Gallery {
    associatedtype Image

    func image(for type: GalleryType) -> Image
}

public extension Gallery {
    var landingWelcomeBackground: Image { self.image(for: .landingWelcomeBackground) }
    var landingStartAuthBackground: Image { self.image(for: .landingStartAuthBackground) }
    var landingStartBackground: Image { self.image(for: .landingStartBackground) }
}
