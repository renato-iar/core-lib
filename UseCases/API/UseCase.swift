//
//  UseCase.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

public protocol UseCase {

    associatedtype InputType
    associatedtype OutputType

    func execute(input: InputType) -> OutputType
}
