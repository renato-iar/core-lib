import SwiftUI
import Theming_API

public struct ConcreteGallery {

    // MARK: Properties

    private var cachedGallery: [GalleryType: CachedImage] = [:]

    // MARK: Initializers

    init(with gallery: [GalleryType: CachedImage]) {
        self.cachedGallery = gallery
    }

    public init(from decoder: Decoder) throws {
        self.cachedGallery = try decoder.singleValueContainer()
                                        .decode([CachedImage].self)
                                        .reduce(into: [:]) { result, descriptor in
                                            if let type = GalleryType(rawValue: descriptor.type) {
                                                result[type] = descriptor
                                            }
                                        }
    }
}

// MARK: - Gallery

extension ConcreteGallery: Gallery {
    public func image(for type: GalleryType) -> SwiftUI.Image {
        if let cached = self.cachedGallery[type] {
            return Image(cached.name, bundle: cached.bundle)
        } else {
            return Image(uiImage: UIImage())
        }
    }
}

// MARK: - Decodable

extension ConcreteGallery: Decodable { }

// MARK: - Types

extension ConcreteGallery {
    struct CachedImage: Decodable {
        let type: String
        let name: String
        let bundle: Bundle?

        init(type: String, name: String, bundle: Bundle?) {
            self.type = type
            self.name = name
            self.bundle = bundle
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.type = try container.decode(String.self, forKey: .type)
            self.name = try container.decode(String.self, forKey: .name)

            if let bundleName = try? container.decode(String.self, forKey: .bundle) {
                self.bundle = Bundle(identifier: bundleName)
            } else {
                self.bundle = nil
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case bundle
    }
}

// MARK: - Default

public extension ConcreteGallery {
    static let `default` = ConcreteGallery(with: [
        .landingStartBackground: .init(type: "landingStartBackground", name: "Landing-01", bundle: nil),
        .landingWelcomeBackground: .init(type: "landingWelcomeBackground", name: "Landing-02", bundle: nil),
        .landingStartAuthBackground: .init(type: "landingStartAuthBackground", name: "Landing-03", bundle: nil)
    ])
}
