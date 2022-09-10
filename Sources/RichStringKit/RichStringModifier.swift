public protocol RichStringModifier {
    associatedtype Body: RichString
    typealias Content = _RichStringModifier_Content<Self>

    func _makeOutput() -> RichStringOutput
    @RichStringBuilder func body(_ content: Content) -> Body
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
    public var body: Body { bodyAccessDisallowed() }

    let content: any RichString

    init(_ content: some RichString) { self.content = content }
}
