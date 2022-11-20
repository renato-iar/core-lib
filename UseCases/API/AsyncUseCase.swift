public protocol AsyncUseCase {
    associatedtype InputType
    associatedtype OutputType

    func execute(input: InputType) async throws -> OutputType
}
