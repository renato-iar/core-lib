import Foundation

public protocol RequestUseCase {
    associatedtype InputType
    associatedtype ResultType
    associatedtype ErrorType: Error

    func execute(input: InputType, completion: @escaping (Swift.Result<ResultType, ErrorType>) -> Void)
}
