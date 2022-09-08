@resultBuilder
public enum RichStringBuilder {
    public static func buildBlock() -> some RichString {
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

    public static func buildEither<Content>(
        first content: Content
    ) -> Content where Content: RichString {
        content
    }

    public static func buildEither<Content>(
        second content: Content
    ) -> Content where Content: RichString {
        content
    }

    public static func buildLimitedAvailability<Content>(
        _ content: Content
    ) -> Content where Content: RichString {
        content
    }
}
