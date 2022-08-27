public struct BaselineOffset: RichStringModifier {
    public typealias Body = Never

    public let offset: Double

    public init(_ offset: Double) {
        self.offset = offset
    }
}
