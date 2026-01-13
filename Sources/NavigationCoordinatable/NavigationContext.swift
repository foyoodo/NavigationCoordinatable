import SwiftUI

public final class NavigationContext<T: NavigationCoordinatable>: ObservableObject {

    let initial: KeyPath<T, Transition<T, RootRouteType, Void, AnyView>>

    weak var root: (any NavigationCoordinatable)?
    weak var parent: (any NavigationCoordinatable)?

    public var shouldCompatibleWithUIKit: Bool = false

    @Published var path = NavigationPath()

    @Published var lastItem: AnyTransitionItem?

    public init(initial: KeyPath<T, Transition<T, RootRouteType, Void, AnyView>>) {
        self.initial = initial
    }

    func append<Item: TransitionItem>(_ item: Item) {
        if #available(iOS 16.0, *), !shouldCompatibleWithUIKit {
            switch item.transitionType {
            case .modal:
                lastItem = .init(item)
            case .push:
                if let root = root ?? parent {
                    root.path.append(item)
                } else {
                    path.append(item)
                }
            }
        } else {
            lastItem = .init(item)
        }
    }

    func append<Item: IdentifiableNavigationItemType>(_ item: Item) {
        if #available(iOS 16.0, *), !shouldCompatibleWithUIKit {
            if let root = root ?? parent {
                root.path.append(item)
            } else {
                path.append(item)
            }
        } else {
            lastItem = .init(item)
        }
    }

    func removeLast() {
        if let _ = lastItem {
            lastItem = nil
            return
        }

        var item: NavigationItem?
        if let root = root ?? parent {
            item = root.path.popLast()
        } else {
            item = path.popLast()
        }

        if item == nil {
            var p = parent
            while let parent {
                if let _ = parent.lastItem {
                    parent.lastItem = nil
                    break
                }
                p = parent.parent
            }
        }
    }

    func removeAll() {
        guard let root = root ?? parent else { return }
        if let _ = root.lastItem {
            root.lastItem = nil
        } else {
            lastItem = nil
            if root.path.isEmpty {
                var p = parent
                while let parent {
                    parent.lastItem = nil
                    p = parent
                }
            } else {
                root.path.removeAll()
            }
        }
    }
}

extension NavigationCoordinatable {

    fileprivate var parent: (any NavigationCoordinatable)? {
        context.parent
    }

    fileprivate var path: NavigationPath {
        get { context.path }
        set { context.path = newValue }
    }

    fileprivate var lastItem: AnyTransitionItem? {
        get { context.lastItem }
        set { context.lastItem = newValue }
    }
}
