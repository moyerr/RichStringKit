public struct Formatted: RichString {
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
}

extension Formatted {
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
