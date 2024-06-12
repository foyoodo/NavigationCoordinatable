//
//  CoordinatableContext.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/5/22.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import SwiftUI

protocol CoordinatableContext: ObservableObject {

    func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content: View

    func popLast()

    func popToRoot()
}

extension CoordinatableContext where Self: NavigationCoordinatableContext {

    func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content: View { }

    func popLast() { }

    func popToRoot() { }
}

class NavigationModelCoordinatableContext: CoordinatableContext {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func route<Content>(@ViewBuilder _ view: () -> Content, animated: Bool) where Content : View {
        let vc = UIHostingController(rootView: view())
        navigationController?.pushViewController(vc, animated: animated)
    }

    func popLast() {
        navigationController?.popViewController(animated: true)
    }

    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

class NavigationCoordinatableContext: CoordinatableContext {

    @Published var path = NavigationPath()

    weak var root: (any NavigationCoordinatable)?

    init(root: any NavigationCoordinatable) {
        self.root = root
    }
}
