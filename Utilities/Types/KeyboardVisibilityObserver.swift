//
//  KeyboardVisibilityObserver.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 22/08/2022.
//

import Combine
import UIKit

public final class KeyboardVisibilityObserver: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []

    public private(set) final var isKeyboardVisible: Bool = false {
        willSet {
            self.objectWillChange.send()
        }
    }

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .sink { [weak self] _ in self?.isKeyboardVisible = true }
            .store(in: &self.cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
            .sink { [weak self] _ in self?.isKeyboardVisible = false }
            .store(in: &self.cancellables)
    }
}
