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
        Group {
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, *), !context.shouldCompatibleWithUIKit {
                viewImplementation
            } else {
                deprecatedViewImplementation
            }
        }
        .sheet(
            isPresented: .init(get: {
                presentationHelper.presented?.transitionType == .modal
            }, set: { newValue in
                if !newValue {
                    presentationHelper.presented = nil
                }
            })
        ) {
            if let view = presentationHelper.presented?.content {
                return view
            }
            return AnyView(EmptyView())
        }
        .environmentObject(coordinator)
        .environmentObject(NamespaceContainer(namespace))
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
    @ViewBuilder private var viewImplementation: some View {
        if context.root == nil {
            NavigationStack(path: $context.path) {
                coordinator.root
                    .navigationDestination(for: NavigationItem.self) { item in
                        switch item {
                        case let .item(item):
                            item.content
                        case let .identifiableItem(item):
                            item.content
                        }
                    }
            }
        } else {
            coordinator.root
        }
    }

    @ViewBuilder private var deprecatedViewImplementation: some View {
        if context.root == nil, !context.shouldCompatibleWithUIKit {
            NavigationView {
                coordinator.root
                    .background {
                        NavigationLink(
                            destination: {
                                if let view = presentationHelper.presented?.content {
                                    return view
                                }
                                return AnyView(EmptyView())
                            }(),
                            isActive: .init(get: {
                                presentationHelper.presented?.transitionType == .push
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
            }
            .navigationViewStyle(.stack)
        } else {
            coordinator.root
                .background {
                    NavigationLink(
                        destination: {
                            if let view = presentationHelper.presented?.content {
                                return view
                            }
                            return AnyView(EmptyView())
                        }(),
                        isActive: .init(get: {
                            presentationHelper.presented?.transitionType == .push
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
        }
    }
}

public final class NamespaceContainer: ObservableObject {
    public let namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
