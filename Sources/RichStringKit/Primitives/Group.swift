public struct Group<Content>: RichString where Content: RichString {
    public let body: Content

    public init(@RichStringBuilder _ content: () -> Content) {
        self.body = content()
    }
}
