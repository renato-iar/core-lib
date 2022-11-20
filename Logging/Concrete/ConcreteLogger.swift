import Foundation
import os.log

import Logging_API
import Utilities

public actor ConcreteLogger {
    private var consumers: [LoggerConsumer] = []

    public init(consumers: [LoggerConsumer] = []) {
        self.consumers = consumers
    }
}

// MARK: - Convenience

public extension ConcreteLogger {
    init(with consumers: LoggerConsumer ...) {
        self.init(consumers: consumers)
    }
}

// MARK: - Logger

extension ConcreteLogger: Logging {
    public func log(_ message: String, level: LogLevel) {
        let output = "[\(level.rawValue)] - \(message)"

        Task {
            for consumer in self.consumers {
                await consumer.consume(output)
            }
        }
    }
}

// MARK: - Shared

extension ConcreteLogger: Shareable {
    public static let shared = ConcreteLogger(with: PrintLoggerConsumer())
}
