import Foundation

public protocol Queueable {
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
    func async(execute dispatchWorkItem: DispatchWorkItem)
    func asyncAfter(deadline: DispatchTime, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
}

public extension Queueable {
    func async(execute work: @escaping @convention(block) () -> Void) {
        self.async(execute: DispatchWorkItem(block: work))
    }

    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        self.asyncAfter(deadline: deadline, qos: .default, flags: .inheritQoS, execute: work)
    }
}

//DispatchQueue.main.async
extension DispatchQueue: Queueable { }
