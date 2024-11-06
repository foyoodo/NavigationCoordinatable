#if os(iOS)
import SwiftUI

private struct ZoomTransitionModifier<ID: Hashable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .navigationTransition(
                    .zoom(
                        sourceID: id,
                        in: namespace
                    )
                )
        } else {
            content
        }
    }
}

private struct ZoomTransitionSourceModifier<ID: Hashable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .matchedTransitionSource(
                    id: id,
                    in: namespace
                )
        } else {
            content
        }
    }
}

extension View {
    public func zoomTransition<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        self.modifier(ZoomTransitionModifier(id: id, namespace: namespace))
    }

    public func zoomTransitionSource<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        self.modifier(ZoomTransitionSourceModifier(id: id, namespace: namespace))
    }
}
#endif
