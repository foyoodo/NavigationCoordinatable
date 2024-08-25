//
//  CoordinatableContext.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/5/22.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import SwiftUI

public protocol CoordinatableContext: ObservableObject {

    func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content: View

    func popLast()

    func popToRoot()
}

extension CoordinatableContext where Self: NavigationCoordinatableContext {

    public func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content: View {
        path.append(NavigationStackItem(keyPath: UUID().hashValue, viewRepresent: AnyView(view())))
    }

    public func popLast() { }

    public func popToRoot() { }
}

public final class NavigationModelCoordinatableContext: CoordinatableContext {

    weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    public func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content : View {
        let vc = UIHostingController(rootView: view())
        navigationController?.pushViewController(vc, animated: animated)
    }

    public func popLast() {
        navigationController?.popViewController(animated: true)
    }

    public func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

public class NavigationCoordinatableContext: CoordinatableContext {

    @Published var path = NavigationPath()

    weak var root: (any NavigationCoordinatable)?

    init(root: any NavigationCoordinatable) {
        self.root = root
    }
}
