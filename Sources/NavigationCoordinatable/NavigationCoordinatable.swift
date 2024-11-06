import SwiftUI

public protocol Coordinatable: ObservableObject, ViewRepresentable {

}

public protocol NavigationCoordinatable: Coordinatable {
    typealias Route = NavigationRoute

    associatedtype Root: View

    var context: (any CoordinatableContext)? { get set }

    @ViewBuilder var root: Root { get }
}

extension NavigationCoordinatable {
    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, Presentation, Input, Output>>,
        input: Input
    ) -> Output {
        let transition = self[keyPath: route]
        let output = transition.represented(of: self, input: input)
        output.context = context

        if case let context as NavigationCoordinatableContext = context {
            context.path.append(
                NavigationItem(
                    keyPath: route.hashValue,
                    viewRepresent: output
                )
            )
        } else {
            context?.route(output.rootView, animated: true)
        }

        return output
    }

    @discardableResult
    public func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, Presentation, Void, Output>>
    ) -> Output {
        self.route(to: route, input: ())
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Input, Output>>,
        input: Input
    ) -> Output where T.Input == Input {
        let transition = self[keyPath: route]
        let output = transition.represented(of: self, input: input)
        output.context = context

        if case let context as NavigationCoordinatableContext = context {
            context.path.append(
                NavigationIdentifiableItem(
                    id: transition.type.transform(input: input),
                    viewRepresent: output,
                    transitionStyle: transition.type.transitionStyle
                )
            )
        } else {
            context?.route(output.rootView, animated: true)
        }

        return output
    }

    @discardableResult
    public func route<T: IdentifiableRouteType, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, T, Void, Output>>
    ) -> Output where T.Input == Void {
        self.route(to: route, input: ())
    }

    public func popToRoot() {
        if let context = context as? NavigationCoordinatableContext {
            context.path.removeLast(context.path.count)
        } else {
            context?.popToRoot()
        }
    }

    public func popLast() {
        if let context = context as? NavigationCoordinatableContext, context.path.count > 0 {
            context.path.removeLast()
        } else {
            context?.popLast()
        }
    }

    public func rootView() -> some View {
        root.environmentObject(self)
    }

    public func view() -> AnyView {
        if context == nil {
            context = NavigationCoordinatableContext(root: self)
        }
        return AnyView(NavigationCoordinatableView(coordinator: self).environmentObject(context!))
    }
}
