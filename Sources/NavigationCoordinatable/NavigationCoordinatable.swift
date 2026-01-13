import SwiftUI

public protocol Coordinatable: ObservableObject, ViewRepresentable {

}

public protocol NavigationCoordinatable: Coordinatable {

    typealias Root = NavigationRoot

    typealias Route = NavigationRoute

    var context: NavigationContext<Self> { get }
}

extension NavigationCoordinatable {

    var root: some View {
        self[keyPath: context.initial].representation(of: self).content
    }

    public var content: some View {
        NavigationCoordinatableView(coordinator: self)
    }
}

// MARK: - Presentation

extension NavigationCoordinatable {

    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, ModalRouteType, Input, Output>>,
        input: Input
    ) -> Output
    {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)
        output.context.parent = self

        context.append(AnyTransitionItem(output, transitionType: .modal))

        return output
    }

    @discardableResult
    public func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, ModalRouteType, Void, Output>>
    ) -> Output
    {
        self.route(to: route, input: ())
    }
}

// MARK: - Navigation

extension NavigationCoordinatable {

    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, PushRouteType, Input, Output>>,
        input: Input
    ) -> Output
    {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)

        output.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        output.context.parent = self
        output.context.root = context.root ?? context.parent ?? self

        context.append(AnyNavigationItem(output))

        return output
    }

    @discardableResult
    public func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, PushRouteType, Void, Output>>
    ) -> Output
    {
        self.route(to: route, input: ())
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Input, Output>>,
        input: Input
    ) -> Output where T.Input == Input
    {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)

        output.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        output.context.parent = self
        output.context.root = context.root ?? context.parent ?? self

        context.append(AnyNavigationItem(output))

        return output
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Void, Output>>
    ) -> Output where T.Input == Void
    {
        self.route(to: route, input: ())
    }

    @discardableResult
    public func route<Content: View>(to content: Content) -> ViewRepresentable {
        let coordinator = AnyNavigationCoordinator(content: content)
        coordinator.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        coordinator.context.parent = self
        coordinator.context.root = context.root ?? context.parent ?? self
        context.append(AnyNavigationItem(coordinator))
        return coordinator
    }
}

extension NavigationCoordinatable {

    public func popLast() {
        context.removeLast()
    }

    public func popToRoot() {
        context.removeAll()
    }
}
