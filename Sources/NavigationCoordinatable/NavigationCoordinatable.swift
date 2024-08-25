//
//  NavigationCoordinatable.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/5/16.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import SwiftUI

public protocol ViewRepresentable {

    func view() -> AnyView
}

public protocol Coordinatable: ObservableObject, ViewRepresentable {

}

public protocol NavigationCoordinatable: Coordinatable {

    typealias Route = NavigationRoute

    associatedtype Root: View

    var context: (any CoordinatableContext)? { get set }

    @ViewBuilder var root: Root { get }

    func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, Input, Output>>,
        input: Input
    ) -> Output

    func route<Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, Void, Output>>
    ) -> Output
}

extension AnyView: ViewRepresentable {

    public func view() -> AnyView {
        self
    }
}

extension NavigationCoordinatable {

    @discardableResult
    public func route<Input, Output: NavigationCoordinatable>(
        to route: KeyPath<Self, Transition<Self, Input, Output>>,
        input: Input
    ) -> Output {
        let transition = self[keyPath: route]
        let output = transition.closure(self)(input)
        output.context = context

        if let context = context as? NavigationCoordinatableContext {
            context.path.append(
                NavigationStackItem(
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
        to route: KeyPath<Self, Transition<Self, Void, Output>>
    ) -> Output {
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

struct NavigationStackItem: Hashable {

    let keyPath: Int
    let viewRepresent: ViewRepresentable

    func hash(into hasher: inout Hasher) {
        hasher.combine(keyPath)
    }

    static func == (lhs: NavigationStackItem, rhs: NavigationStackItem) -> Bool {
        lhs.keyPath == rhs.keyPath
    }
}

public struct Transition<T: NavigationCoordinatable, Input, Output: ViewRepresentable> {

    let closure: (T) -> (Input) -> (Output)
}

@propertyWrapper 
public struct NavigationRoute<T: NavigationCoordinatable, Input, Output: ViewRepresentable> {

    public var wrappedValue: Transition<T, Input, Output>

    init(standard: Transition<T, Input, Output>) {
        self.wrappedValue = standard
    }
}

extension NavigationRoute {

    public init(wrappedValue: @escaping (T) -> (Input) -> (Output)) {
        self.init(standard: .init(closure: wrappedValue))
    }

    public init(wrappedValue: @escaping (T) -> () -> (Output)) where Input == Void {
        self.init(standard: .init(closure: { coordinator in
            { _ in wrappedValue(coordinator)() }
        }))
    }
}
