import SwiftUI

public final class NavigationContext<T: NavigationCoordinatable>: ObservableObject {
    let initial: KeyPath<T, Transition<T, RootRouteType, Void, AnyView>>

    weak var root: (any NavigationCoordinatable)?
    weak var parent: (any NavigationCoordinatable)?

    public var shouldCompatibleWithUIKit: Bool = false

    @Published var path = NavigationPath()
    @Published var lastPathItem: (any Hashable)?

    public init(initial: KeyPath<T, Transition<T, RootRouteType, Void, AnyView>>) {
        self.initial = initial
    }
}
