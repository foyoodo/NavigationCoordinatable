import SwiftUI

public protocol ViewRepresentable {
    associatedtype Represented: View

    func view() -> Represented
}

extension AnyView: ViewRepresentable {
    public func view() -> AnyView { self }
}
