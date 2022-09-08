public struct Concatenate: RichString {
    public typealias Body = Never
    public typealias Contents = [any RichString]

    public let contents: Contents

    public init(_ contents: Contents) {
        self.contents = contents
    }

    public init(_ contents: (any RichString)...) {
        self.contents = contents
    }
}
