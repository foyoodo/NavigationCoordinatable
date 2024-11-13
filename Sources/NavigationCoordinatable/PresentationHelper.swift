import SwiftUI
import Combine

final class PresentationHelper<T: NavigationCoordinatable>: ObservableObject {
    @Published var presented: AnyView?

    var cancellables = Set<AnyCancellable>()

    init(coordinator: T) {
        coordinator.context.$lastPathItem
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                if case let item as NavigationItem = item {
                    self?.presented = AnyView(item.viewRepresent.view())
                }
            }
            .store(in: &cancellables)
    }
}
