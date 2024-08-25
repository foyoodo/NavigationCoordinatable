//
//  CoordinatableViewController.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/6/4.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import UIKit

public protocol CoordinatableViewController: UIViewController {

    var coordinatableContext: (any CoordinatableContext)? { get set }

    var resolvedNavigationController: UINavigationController? { get }
}

extension CoordinatableViewController {

    public var resolvedNavigationController: UINavigationController? {
        if case let navigationContext as NavigationModelCoordinatableContext = coordinatableContext {
            return navigationContext.navigationController ?? navigationController
        }
        return navigationController
    }

    public func push(_ viewController: UIViewController, animated: Bool) {
        resolvedNavigationController?.pushViewController(viewController, animated: animated)
    }
}
