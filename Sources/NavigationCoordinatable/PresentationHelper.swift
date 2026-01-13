import Combine
import SwiftUI

final class PresentationHelper<T: NavigationCoordinatable>: ObservableObject {

    @Published var presented: AnyTransitionItem?

    private var lastItemSubscription: AnyCancellable?

    init(coordinator: T) {
        lastItemSubscription = coordinator.context.$lastItem
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self, let item else { self?.presented = nil; return }
                presented = item
            }
    }
}
