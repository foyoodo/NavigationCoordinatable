import Foundation

public protocol RouteType {

}

public protocol PresentationRouteType: RouteType {

}

public protocol IdentifiableRouteType: PresentationRouteType {
    associatedtype Input

    var transitionStyle: TransitionStyle { get }

    func transform(input: Input) -> String
}

public struct RootRouteType: RouteType {

}

public struct PushRouteType: PresentationRouteType {

}

extension RouteType where Self == PushRouteType {
    public static var push: PushRouteType { .init() }
}

public struct ModalRouteType: PresentationRouteType {

}

extension RouteType where Self == ModalRouteType {
    public static var modal: ModalRouteType { .init() }
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
