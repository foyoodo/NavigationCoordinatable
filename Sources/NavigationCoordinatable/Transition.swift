import SwiftUI

public struct Transition<T: NavigationCoordinatable, U: RouteType, Input, Output: ViewRepresentable> {
    let type: U
    let closure: (T) -> (Input) -> (Output)

    init(type: U, closure: @escaping (T) -> (Input) -> (Output)) {
        self.type = type
        self.closure = closure
    }

    func representation(of coordinator: T, input: Input) -> Output {
        closure(coordinator)(input)
    }

    func representation(of coordinator: T) -> Output where Input == Void {
        closure(coordinator)(())
    }
}

public struct RootTransition<T: NavigationCoordinatable, Root: View> {
    let closure: (T) -> Root

    func represented(of coordinator: T) -> Root {
        closure(coordinator)
    }
}
