//
//  TimestampProvider.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation

public protocol TimestampProvider {
    func current() -> TimeInterval
}
