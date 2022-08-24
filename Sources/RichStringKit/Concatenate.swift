public struct Concatenate: RichString {
    public typealias Body = Never
    public typealias Joined = [any RichString]

    public let value: Joined

    public init(_ value: Joined) {
        self.value = value
    }
}
