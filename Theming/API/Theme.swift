//
//  Theme.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import SwiftUI

public protocol Theme: ObservableObject {

    var name: String { get }

    var palette: any ColorPalette { get }
    var typography: any Typography { get }
    var icongraphy: any Iconography { get }
    var gallery: any Gallery { get }
}
