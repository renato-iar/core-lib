//
//  PrintLoggerConsumer.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Foundation

import Logging_API

actor PrintLoggerConsumer: LoggerConsumer {
    func consume(_ log: String) async {
        print(log)
    }
}
