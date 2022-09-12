//
//  PublishedUseCase.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 20/08/2022.
//

import Combine
import SwiftUI

public protocol PublishedUseCase<PublishedType, ErrorType>: ObservableObject {

    associatedtype PublishedType
    associatedtype ErrorType: Error = Never

    var publisher: any Publisher<PublishedType, ErrorType> { get }
}
