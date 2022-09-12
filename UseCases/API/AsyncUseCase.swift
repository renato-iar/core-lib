//
//  AsyncUseCase.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

public protocol AsyncUseCase {

    associatedtype InputType
    associatedtype OutputType

    func execute(input: InputType) async throws -> OutputType
}
