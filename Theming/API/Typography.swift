public protocol Typography {
    associatedtype Font

    func font(for type: TypographyType) -> Font
}

public extension Typography {
    var body: Font { self.font(for: .body) }
    var bodyBold: Font { self.font(for: .bodyBold) }
    var title: Font { self.font(for: .title) }
    var largeTitle: Font { self.font(for: .largeTitle) }
    var largeTitleThin: Font { self.font(for: .largeTitleThin) }
    var subtitle: Font { self.font(for: .subtitle) }
    var caption: Font { self.font(for: .caption) }
    var action: Font { self.font(for: .action) }
    var footnote: Font { self.font(for: .footnote) }
}

