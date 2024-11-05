import Foundation

public protocol RouteType {

}

public protocol IdentifiableRouteType: RouteType {
    associatedtype Input

    var transitionStyle: TransitionStyle { get }

    func transform(input: Input) -> String
}

public struct Presentation: RouteType {
    let type: PresentationType
}

public struct ZoomTransition<Input>: IdentifiableRouteType {
    let closure: (_ input: Input) -> String

    public var transitionStyle: TransitionStyle { .zoom }

    public init(transform: @escaping (_ input: Input) -> String) {
        self.closure = transform
    }

    public init(id: String) where Input == Void {
        self.closure = { _ in id }
    }

    public func transform(input: Input) -> String {
        closure(input)
    }
}

extension RouteType where Self == Presentation {
    public static var modal: Presentation {
        .init(type: .modal)
    }

    public static var push: Presentation {
        .init(type: .push)
    }
}

extension RouteType where Self == ZoomTransition<Void> {
    public static func zoom(_ id: String) -> ZoomTransition<Void> {
        .init(id: id)
    }
}

extension ZoomTransition {
    public static func zoom(_ transform: @escaping (Input) -> String) -> ZoomTransition<Input> {
        .init(transform: transform)
    }
}
