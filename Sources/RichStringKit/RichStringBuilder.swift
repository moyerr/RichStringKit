@resultBuilder
public enum RichStringBuilder {

    public static func buildExpression<Content>(
        _ expression: Content?
    ) -> ConditionalContent<Content, EmptyString> where Content: RichString {
        if let content = expression {
            return ConditionalContent(storage: .trueContent(content))
        } else {
            return ConditionalContent(storage: .falseContent(EmptyString()))
        }
    }

    public static func buildExpression(
        _ expression: Never
    ) -> Never { /* Cannot be executed */ }

    public static func buildExpression<Content>(
        _ expression: Content
    ) -> Content where Content: RichString {
        expression
    }

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

    public static func buildArray(
        _ components: [any RichString]
    ) -> Concatenate {
        Concatenate(components)
    }

    public static func buildEither<TrueContent, FalseContent>(
        first: TrueContent
    ) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: RichString, FalseContent: RichString {
        ConditionalContent(storage: .trueContent(first))
    }

    public static func buildEither<TrueContent, FalseContent>(
        second: FalseContent
    ) -> ConditionalContent<TrueContent, FalseContent> where TrueContent: RichString, FalseContent: RichString {
        ConditionalContent(storage: .falseContent(second))
    }

    public static func buildLimitedAvailability<Content>(
        _ content: Content
    ) -> Content where Content: RichString {
        content
    }
}
