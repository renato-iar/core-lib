import Foundation

import Logging_API

actor PrintLoggerConsumer: LoggerConsumer {
    func consume(_ log: String) async {
        print(log)
    }
}
