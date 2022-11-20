import Combine

public protocol UpdatableAsyncPublishedUseCase<InputType>: PublishedUseCase {
    associatedtype InputType = Void

    var updating: any Publisher<Bool, Never> { get }

    func update(_ input: InputType) async throws
}

extension UpdatableAsyncPublishedUseCase {
    public func update(_ input: InputType) {
        Task { [weak self] in try await self?.update(input) }
    }
}

extension UpdatableAsyncPublishedUseCase where InputType == Void {
    public func update() async throws { try await self.update(()) }
    public func update() { self.update(()) }
}
