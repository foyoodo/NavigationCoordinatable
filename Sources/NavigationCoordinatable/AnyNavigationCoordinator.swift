import SwiftUI

public final class AnyNavigationCoordinator: @preconcurrency NavigationCoordinatable {

    public var context: NavigationContext<AnyNavigationCoordinator> = .init(initial: \.start)

    @Root var start = makeStart

    private var view: AnyView

    init<Content: View>(content: Content) {
        self.view = AnyView(content)
    }

    func makeStart() -> some View {
        view
    }
}
