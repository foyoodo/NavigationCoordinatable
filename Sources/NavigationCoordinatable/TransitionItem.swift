import SwiftUI

public enum TransitionStyle {
    case zoom
}

enum TransitionType {
    case modal
    case push
}

public protocol ViewRepresentable {

    associatedtype Content: View

    var content: Content { get }
}

protocol TransitionItem: ViewRepresentable {

    var transitionType: TransitionType { get }
}

protocol IdentifiableNavigationItemType: TransitionItem {

    var transitionStyle: TransitionStyle { get }
}

struct AnyTransitionItem: TransitionItem {

    let content: AnyView

    let transitionType: TransitionType

    init<Item: TransitionItem>(_ item: Item, transitionType: TransitionType? = nil) {
        self.content = AnyView(item.content)
        self.transitionType = transitionType ?? item.transitionType
    }

    init<Item: TransitionItem>(_ item: Item, transitionType: TransitionType? = nil) where Item.Content == AnyView {
        self.content = item.content
        self.transitionType = transitionType ?? item.transitionType
    }

    @_disfavoredOverload
    init<T: ViewRepresentable>(_ representation: T, transitionType: TransitionType = .push) {
        self.content = AnyView(representation.content)
        self.transitionType = transitionType
    }

    @_disfavoredOverload
    init<T: ViewRepresentable>(_ representation: T, transitionType: TransitionType = .push) where T.Content == AnyView {
        self.content = representation.content
        self.transitionType = transitionType
    }
}

extension AnyView: TransitionItem {

    public var content: AnyView { self }

    var transitionType: TransitionType { .push }
}
