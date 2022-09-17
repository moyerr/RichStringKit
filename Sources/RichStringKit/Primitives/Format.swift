@available(iOS 16, tvOS 16, watchOS 9, macOS 13, *)
public struct Format: RichString {
    public typealias Body = Never

    let formatString: String
    let args: [any RichString]

    public init(
        _ formatString: String,
        _ args: (any RichString)...
    ) {
        self.formatString = formatString
        self.args = args
    }

    public var body: Body {
        bodyAccessDisallowed()
    }
}

@available(iOS 16, tvOS 16, watchOS 9, macOS 13, *)
extension Format {
    public init(
        _ formatString: String,
        @RichStringBuilder arg0: () -> some RichString
    ) {
        self.formatString = formatString
        self.args = [arg0()]
    }

    public init(
        _ formatString: String,
        @RichStringBuilder arg0: () -> some RichString,
        @RichStringBuilder arg1: () -> some RichString
    ) {
        self.formatString = formatString
        self.args = [arg0(), arg1()]
    }

    public init(
        _ formatString: String,
        @RichStringBuilder arg0: () -> some RichString,
        @RichStringBuilder arg1: () -> some RichString,
        @RichStringBuilder arg2: () -> some RichString
    ) {
        self.formatString = formatString
        self.args = [arg0(), arg1(), arg2()]
    }

    public init(
        _ formatString: String,
        @RichStringBuilder arg0: () -> some RichString,
        @RichStringBuilder arg1: () -> some RichString,
        @RichStringBuilder arg2: () -> some RichString,
        @RichStringBuilder arg3: () -> some RichString
    ) {
        self.formatString = formatString
        self.args = [arg0(), arg1(), arg2(), arg3()]
    }
}
