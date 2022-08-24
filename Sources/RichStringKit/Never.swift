extension Never: RichString {
    public typealias Body = Never
}

extension RichString where Body == Never {
    public var body: Body { fatalError() }
}

extension RichStringModifier where Body == Never {
    public func modify(_ content: Self.Content) -> Body {
        fatalError()
    }
}
