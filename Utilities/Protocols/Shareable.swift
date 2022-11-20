/**
 Represents types that may contain a shared instance.

 The type may be associated directly with the dependency, or possibly on an extension for injection defaulting, as described bellow:
 ```
 class SomeType<T> {
    private let dependency: T

    init(dependency: T) {
        self.dependency = dependency
    }
 }

 extension SomeType where T: Shareable {
    convenience init(with dependency: T = T.shared) {
        self.init(dependency: dependency)
    }
 }
 ```
 */
public protocol Shareable {
    static var shared: Self { get }
}
