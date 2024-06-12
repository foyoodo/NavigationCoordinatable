//
//  NavigationCoordinatableView.swift
//  NavigationCoordinatable
//
//  Created by foyoodo on 2024/5/16.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import SwiftUI

struct NavigationCoordinatableView<T: NavigationCoordinatable>: View {

    var coordinator: T

    @EnvironmentObject var context: NavigationCoordinatableContext

    var body: some View {
        universalView
            .environmentObject(coordinator)
    }

    @ViewBuilder
    var universalView: some View {
        if context.root === coordinator {
            NavigationStack(path: $context.path) {
                coordinator.root
                    .navigationDestination(for: NavigationStackItem.self) { stackItem in
                        stackItem.viewRepresent.view()
                    }
            }
        } else {
            coordinator.root
        }
    }
}
