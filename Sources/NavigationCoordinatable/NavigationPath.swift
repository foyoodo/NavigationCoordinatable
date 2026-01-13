struct NavigationPath {

    private var items: [NavigationItem] = []

    mutating func append<Item: TransitionItem>(_ item: Item) {
        items.append(.item(AnyNavigationItem(item)))
    }

    mutating func append<Item: IdentifiableNavigationItemType>(_ item: Item) {
        items.append(.identifiableItem(AnyIdentifiableNavigationItem(item)))
    }
}

extension NavigationPath: RandomAccessCollection, MutableCollection {

    var startIndex: Int {
        items.startIndex
    }

    var endIndex: Int {
        items.endIndex
    }

    subscript(position: Int) -> NavigationItem {
        _read {
            yield items[position]
        }
        _modify {
            yield &items[position]
        }
    }
}

extension NavigationPath: RangeReplaceableCollection {

    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, NavigationItem == C.Element {
        items.replaceSubrange(subrange, with: newElements)
    }
}
