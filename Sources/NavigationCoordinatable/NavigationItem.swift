import Foundation
import SwiftUI

struct AnyNavigationItem: TransitionItem {

    private let id = UUID().uuidString

    let content: AnyView

    var transitionType: TransitionType { .push }

    init<Item: TransitionItem>(_ item: Item) {
        self.content = AnyView(item.content)
    }

    init<Item: TransitionItem>(_ item: Item) where Item.Content == AnyView {
        self.content = item.content
    }

    init<T: ViewRepresentable>(_ representation: T) {
        self.content = AnyView(representation.content)
    }

    init<T: ViewRepresentable>(_ representation: T) where T.Content == AnyView {
        self.content = representation.content
    }
}

extension AnyNavigationItem: Hashable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct AnyIdentifiableNavigationItem: IdentifiableNavigationItemType {

    private let id = UUID().uuidString

    let content: AnyView

    let transitionType: TransitionType

    let transitionStyle: TransitionStyle

    init<Item: IdentifiableNavigationItemType>(_ item: Item) {
        self.content = AnyView(item.content)
        self.transitionType = item.transitionType
        self.transitionStyle = item.transitionStyle
    }
}

extension AnyIdentifiableNavigationItem: Hashable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum NavigationItem: Hashable {

    case item(AnyNavigationItem)

    case identifiableItem(AnyIdentifiableNavigationItem)
}

extension NavigationItem: TransitionItem {

    var content: AnyView {
        switch self {
        case let .item(item): item.content
        case let .identifiableItem(item): item.content
        }
    }

    var transitionType: TransitionType {
        switch self {
        case let .item(item): item.transitionType
        case let .identifiableItem(item): item.transitionType
        }
    }
}
