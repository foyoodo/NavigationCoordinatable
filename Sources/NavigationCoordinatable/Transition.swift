import Foundation

public struct Transition<T: NavigationCoordinatable, U: RouteType, Input, Output: ViewRepresentable> {
    let type: U
    let closure: (T) -> (Input) -> (Output)

    init(type: U, closure: @escaping (T) -> (Input) -> (Output)) {
        self.type = type
        self.closure = closure
    }

    func represented(of coordinator: T, input: Input) -> Output {
        closure(coordinator)(input)
    }
}
