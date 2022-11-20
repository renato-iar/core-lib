import UIKit
import Theming_API

public struct ConcreteGallery {

    // MARK: Properties

    private let cachedGallery: [GalleryType: CachedImage]

    // MARK: Initializers

    init(with gallery: [GalleryType: CachedImage]) {
        self.cachedGallery = gallery
    }

    public init(from decoder: Decoder) throws {
        self.cachedGallery = try decoder.singleValueContainer()
                                        .decode([CachedImage].self)
                                        .reduce(into: [:]) { results, descriptor in
                                            if let type = GalleryType(rawValue: descriptor.type) {
                                                results[type] = descriptor
                                            }
                                        }
    }
}

// MARK: - Gallery

extension ConcreteGallery: Gallery {
    public func image(for type: GalleryType) -> UIImage {
        if let cached = self.cachedGallery[type],
           let image = UIImage(named: cached.name, in: cached.bundle, with: nil) {
            return image
        } else {
            return UIImage()
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

        enum CodingKeys: String, CodingKey {
            case type
            case name
            case bundle
        }

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
}

// MARK: - Default

public extension ConcreteGallery {
    static let `default` = ConcreteGallery(with: [
        .landingWelcomeBackground: CachedImage(type: "landingWelcomeBackground", name: "Landing-01", bundle: nil),
        .landingStartAuthBackground: CachedImage(type: "landingStartAuthBackground", name: "Landing-02", bundle: nil),
        .landingStartBackground: CachedImage(type: "landingStartBackground", name: "Landing-03", bundle: nil)
    ])
}
