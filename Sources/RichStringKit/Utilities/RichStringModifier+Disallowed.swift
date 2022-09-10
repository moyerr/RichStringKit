extension RichStringModifier where Body == Never {
    public func body(_ content: Self.Content) -> Body {
        fatalError("The \(#function) method of primitive modifier \(type(of: self)) should not be called.")
    }
}
