//
//  CoordinatableViewController.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/6/4.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import UIKit

protocol CoordinatableViewController: UIViewController {

    var navigationContext: NavigationModelCoordinatableContext? { get set }

    var resolvedNavigationController: UINavigationController? { get }
}

extension CoordinatableViewController {

    var resolvedNavigationController: UINavigationController? {
        navigationContext?.navigationController ?? navigationController
    }

    func push(_ viewController: UIViewController, animated: Bool) {
        resolvedNavigationController?.pushViewController(viewController, animated: animated)
    }
}
