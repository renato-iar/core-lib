//
//  LoggerConsumer.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Foundation

public protocol LoggerConsumer {
    func consume(_ log: String) async
}
