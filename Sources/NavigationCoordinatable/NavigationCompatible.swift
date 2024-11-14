public protocol NavigationCompatible {

}

extension NavigationCompatible where Self: NavigationCoordinatable {
    public func representation<Input, Output: NavigationCoordinatable>(
        of route: KeyPath<Self, Transition<Self, PushRouteType, Input, Output>>,
        input: Input
    ) -> Output.Represented {
        let transition = self[keyPath: route]
        let output = transition.representation(of: self, input: input)
        output.context.shouldCompatibleWithUIKit = context.shouldCompatibleWithUIKit
        output.context.parent = self
        output.context.root = context.root ?? context.parent ?? self
        return output.view()
    }

    public func representation<Output: NavigationCoordinatable>(
        of route: KeyPath<Self, Transition<Self, PushRouteType, Void, Output>>
    ) -> Output.Represented {
        self.representation(of: route, input: ())
    }
}
