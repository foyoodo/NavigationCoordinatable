#if os(iOS)
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
#endif
