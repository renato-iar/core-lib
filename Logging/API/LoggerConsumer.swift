import Foundation

public protocol LoggerConsumer {
    func consume(_ log: String) async
}
