//
//  Typography.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 21/08/2022.
//

import SwiftUI

public enum TypographyType: String, CaseIterable {

    case text
    case title
    case largeTitle
    case subtitle
    case caption
}

public protocol Typography {

    var text: Font { get }
    var title: Font { get }
    var largeTitle: Font { get }
    var subtitle: Font { get }
    var caption: Font { get }
}

public extension Typography {

    func font(for type: TypographyType) -> Font {

        switch type {
        case .text: return self.text
        case .title: return self.title
        case .largeTitle: return self.largeTitle
        case .subtitle: return self.subtitle
        case .caption: return self.caption
        }
    }
}

