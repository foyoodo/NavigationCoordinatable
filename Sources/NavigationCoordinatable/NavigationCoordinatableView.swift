import SwiftUI

public struct NavigationCoordinatableView<T: NavigationCoordinatable>: View {
    @Namespace private var namespace

    var coordinator: T

    @EnvironmentObject var context: NavigationCoordinatableContext

    public var body: some View {
        universalView
            .environmentObject(coordinator)
            .environmentObject(NamespaceContainer(namespace))
    }

    @ViewBuilder
    var universalView: some View {
        if context.root === coordinator {
            NavigationStack(path: $context.path) {
                coordinator.root
                    .navigationDestination(for: NavigationItem.self) { stackItem in
                        AnyView(stackItem.viewRepresent.view())
                    }
                    .navigationDestination(for: NavigationIdentifiableItem.self) { item in
                        let view = switch item.transitionStyle {
                        case .zoom: item.viewRepresent.view()
                            #if os(iOS)
                                .zoomTransition(id: item.id, namespace: namespace)
                            #endif
                        }
                        AnyView(view)
                    }
            }
        } else {
            coordinator.root
        }
    }
}

public final class NamespaceContainer: ObservableObject {
    public let namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
