import SwiftUI

public struct NavigationCoordinatableView<T: NavigationCoordinatable>: View {
    @Namespace private var namespace

    var coordinator: T

    @ObservedObject var context: NavigationContext<T>
    @ObservedObject var presentationHelper: PresentationHelper<T>

    init(coordinator: T) {
        self.coordinator = coordinator
        self.context = coordinator.context
        self.presentationHelper = .init(coordinator: coordinator)
    }

    public var body: some View {
        universalView
            .environmentObject(coordinator)
            .environmentObject(NamespaceContainer(namespace))
    }

    @ViewBuilder
    var universalView: some View {
        Group {
            if context.shouldCompatibleWithUIKit {
                coordinator.root
                    .background {
                        NavigationLink(
                            destination: {
                                if let view = presentationHelper.presented?.view {
                                    return view
                                }
                                return AnyView(EmptyView())
                            }(),
                            isActive: .init(get: {
                                presentationHelper.presented?.type == .push
                            }, set: { newValue in
                                if !newValue {
                                    // FIXME: auto pop when quick navigation (zoom transition)
                                    presentationHelper.presented = nil
                                }
                            }),
                            label: {
                                EmptyView()
                            }
                        )
                        .hidden()
                    }
            } else {
                if context.root == nil {
                    NavigationStack(path: $context.path) {
                        coordinator.root
                            .navigationDestination(for: NavigationStackItem.self) { stackItem in
                                AnyView(stackItem.viewRepresent.view())
                            }
                            .navigationDestination(for: NavigationStackIdentifiableItem.self) { item in
                                let view = switch item.transitionStyle {
                                case .zoom: item.viewRepresent.view()
                                    #if !os(macOS)
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
        .sheet(
            isPresented: .init(get: {
                presentationHelper.presented?.type == .modal
            }, set: { newValue in
                if !newValue {
                    presentationHelper.presented = nil
                }
            })
        ) {
            if let view = presentationHelper.presented?.view {
                return view
            }
            return AnyView(EmptyView())
        }
    }
}

public final class NamespaceContainer: ObservableObject {
    public let namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
