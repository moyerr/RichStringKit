public struct ModifiedContent<Content, Modifier> {
    public typealias Body = Never
    public let content: Content
    public let modifier: Modifier

    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedContent: RichString where Content: RichString, Modifier: RichStringModifier {}

extension ModifiedContent: RichStringModifier where Content: RichStringModifier, Modifier: RichStringModifier {}
