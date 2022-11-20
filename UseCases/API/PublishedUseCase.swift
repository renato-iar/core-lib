import Combine
import SwiftUI

public protocol PublishedUseCase<PublishedType, ErrorType>: ObservableObject {
    associatedtype PublishedType
    associatedtype ErrorType: Error = Never

    var publisher: any Publisher<PublishedType, ErrorType> { get }
}
