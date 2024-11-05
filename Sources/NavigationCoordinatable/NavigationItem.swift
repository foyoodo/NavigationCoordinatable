import Foundation

struct NavigationItem: Hashable {
    let keyPath: Int
    let viewRepresent: ViewRepresentable

    func hash(into hasher: inout Hasher) {
        hasher.combine(keyPath)
    }

    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.keyPath == rhs.keyPath
    }
}

struct NavigationIdentifiableItem: Hashable {
    let id: String
    let viewRepresent: ViewRepresentable
    let transitionStyle: TransitionStyle

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: NavigationIdentifiableItem, rhs: NavigationIdentifiableItem) -> Bool {
        lhs.id == rhs.id
    }
}
