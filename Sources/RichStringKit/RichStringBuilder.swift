@resultBuilder
public struct RichStringBuilder {
    public static func buildBlock() -> EmptyString {
        EmptyString()
    }

    public static func buildBlock<Content>(
        _ content: Content
    ) -> Content where Content: RichString {
        content
    }

    @_disfavoredOverload
    public static func buildBlock(
        _ components: any RichString...
    ) -> Concatenate {
        Concatenate(components)
    }

    // MARK: Internal

    static func buildBlock<Content>(
        _ content: Content
    ) -> Never where Content: RichString, Content.Body == Never {
        content.body
    }

}
