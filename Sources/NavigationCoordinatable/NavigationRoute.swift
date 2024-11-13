import SwiftUI

@propertyWrapper
public struct NavigationRoot<T: NavigationCoordinatable, U: ViewRepresentable> {
    public var wrappedValue: Transition<T, RootRouteType, Void, U>

    init(standard: Transition<T, RootRouteType, Void, U>) {
        self.wrappedValue = standard
    }
}

extension NavigationRoot where U == AnyView {
    public init<ViewOutput: View>(wrappedValue: @escaping (T) -> () -> (ViewOutput)) {
        self.init(standard: .init(type: RootRouteType(), closure: { coordinator in
            { _ in AnyView(wrappedValue(coordinator)()) }
        }))
    }
}

@propertyWrapper
public struct NavigationRoute<T: NavigationCoordinatable, U: RouteType, Input, Output: ViewRepresentable> {
    public var wrappedValue: Transition<T, U, Input, Output>

    init(standard: Transition<T, U, Input, Output>) {
        self.wrappedValue = standard
    }
}

extension NavigationRoute {
    public init(
        wrappedValue: @escaping (T) -> (Input) -> (Output),
        _ routeType: U = .push
    ) {
        self.init(standard: .init(type: routeType, closure: wrappedValue))
    }

    public init(
        wrappedValue: @escaping (T) -> () -> (Output),
        _ routeType: U = .push
    ) where Input == Void {
        self.init(
            standard: .init(
                type: routeType,
                closure: { coordinator in
                    { _ in wrappedValue(coordinator)() }
                }
            )
        )
    }

    public init(
        wrappedValue: @escaping (T) -> (Input) -> (Output),
        _ routeType: U
    ) where U: IdentifiableRouteType, U.Input == Input {
        self.init(standard: .init(type: routeType, closure: wrappedValue))
    }

    public init(
        wrappedValue: @escaping (T) -> (Input) -> (Output),
        _ routeType: U
    ) where U == ZoomTransition<Input> {
        self.init(standard: .init(type: routeType, closure: wrappedValue))
    }
}
