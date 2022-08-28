public struct Group<Content>: RichString where Content: RichString {
    var content: Content

    public init(@RichStringBuilder _ content: () -> Content) {
        self.content = content()
    }

    public var body: some RichString {
        content
    }
}
