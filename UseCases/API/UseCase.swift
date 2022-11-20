public protocol UseCase {
    associatedtype InputType
    associatedtype OutputType

    func execute(input: InputType) -> OutputType
}
