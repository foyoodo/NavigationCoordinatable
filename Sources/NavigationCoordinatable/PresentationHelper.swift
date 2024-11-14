import SwiftUI
import Combine

enum PresentationType {
    case modal
    case push
}

struct Presentation {
    var view: AnyView
    var type: PresentationType
}

final class PresentationHelper<T: NavigationCoordinatable>: ObservableObject {
    @Published var presented: Presentation?

    var cancellables = Set<AnyCancellable>()

    init(coordinator: T) {
        coordinator.context.$lastItem
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self, let item else { self?.presented = nil; return }
                presented = .init(view: AnyView(item.viewRepresent.view()), type: item.presentationType)
            }
            .store(in: &cancellables)
    }
}
