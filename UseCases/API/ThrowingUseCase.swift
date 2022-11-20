public protocol ThrowingUseCase {
    associatedtype InputType
    associatedtype OutputType

    func execute(input: InputType) throws -> OutputType
}
