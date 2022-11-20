import Foundation

protocol InputlessRequestUseCase {
    associatedtype ResultType
    associatedtype ErrorType: Error

    func execute(completion: @escaping (Swift.Result<ResultType, ErrorType>) -> Void)
}
