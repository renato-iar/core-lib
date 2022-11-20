import SwiftUI

public extension Color {
    init(hex: Int) {
        self.init(uiColor: UIColor(hex: hex))
    }
}
