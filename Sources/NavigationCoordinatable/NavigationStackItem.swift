import Foundation

struct NavigationStackItem: Hashable {
    let keyPath: Int
    let viewRepresent: any ViewRepresentable

    func hash(into hasher: inout Hasher) {
        hasher.combine(keyPath)
    }

    static func == (lhs: NavigationStackItem, rhs: NavigationStackItem) -> Bool {
        lhs.keyPath == rhs.keyPath
    }
}

struct NavigationStackIdentifiableItem: Hashable {
    let id: String
    let viewRepresent: any ViewRepresentable
    let transitionStyle: TransitionStyle

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: NavigationStackIdentifiableItem, rhs: NavigationStackIdentifiableItem) -> Bool {
        lhs.id == rhs.id
    }
}
