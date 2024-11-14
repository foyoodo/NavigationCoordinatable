import SwiftUI

public protocol Coordinatable: ObservableObject, ViewRepresentable {

}

public protocol NavigationCoordinatable: Coordinatable {
    typealias Root = NavigationRoot
    typealias Route = NavigationRoute

    var context: NavigationContext<Self> { get }
}

extension NavigationCoordinatable {
    var path: NavigationPath {
        get { context.path }
        set { context.path = newValue }
    }
}

extension NavigationCoordinatable {
    public var root: AnyView.Represented {
        self[keyPath: context.initial].representation(of: self).view()
    }

    public func view() -> some View {
        NavigationCoordinatableView(coordinator: self)
    }
}

extension NavigationCoordinatable {
    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, ModalRouteType, Input, Output>>,
        input: Input
    ) -> Output {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)

        context.lastItem = .init(viewRepresent: output, presentationType: .modal)

        return output
    }

    @discardableResult
    public func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, ModalRouteType, Void, Output>>
    ) -> Output {
        self.route(to: route, input: ())
    }
}

extension NavigationCoordinatable {
    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, PushRouteType, Input, Output>>,
        input: Input
    ) -> Output {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)

        output.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        output.context.parent = self
        output.context.root = context.root ?? context.parent ?? self

        let item = NavigationStackItem(
            keyPath: route.hashValue,
            viewRepresent: output
        )
        context.lastItem = .init(viewRepresent: output, presentationType: .push)
        output.context.root?.path.append(item)

        return output
    }

    @discardableResult
    public func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, PushRouteType, Void, Output>>
    ) -> Output {
        self.route(to: route, input: ())
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Input, Output>>,
        input: Input
    ) -> Output where T.Input == Input {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)

        output.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        output.context.parent = self
        output.context.root = context.root ?? context.parent ?? self

        let item = NavigationStackIdentifiableItem(
            id: transition.type.transform(input: input),
            viewRepresent: output,
            transitionStyle: transition.type.transitionStyle
        )
        context.lastItem = .init(viewRepresent: output, presentationType: .push)
        output.context.root?.path.append(item)

        return output
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Void, Output>>
    ) -> Output where T.Input == Void {
        self.route(to: route, input: ())
    }

    public func popLast() {
        context.root?.path.removeLast()
    }

    public func popToRoot() {
        guard let root = context.root else { return }
        root.path.removeLast(root.path.count)
    }
}
