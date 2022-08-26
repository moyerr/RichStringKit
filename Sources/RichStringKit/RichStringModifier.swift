public protocol RichStringModifier {
    associatedtype Body: RichString
    typealias Content = _RichStringModifier_Content<Self>

    func _makeOutput() -> RichStringOutput
    @RichStringBuilder func body(_ content: Content) -> Body
}

extension RichStringModifier where Body == Never {
    public func body(_ content: Self.Content) -> Body {
        // Trap
        preconditionFailure("\(#function) method of primitive type \(String(describing: Self.self)) should not be called")
    }
}

public extension RichStringModifier {
   func concat<Other>(
       _ other: Other
   ) -> ModifiedContent<Self, Other> {
       .init(content: self, modifier: other)
   }
}

public struct _RichStringModifier_Content<Modifier>: RichString where Modifier: RichStringModifier {
    public typealias Body = Never
}
