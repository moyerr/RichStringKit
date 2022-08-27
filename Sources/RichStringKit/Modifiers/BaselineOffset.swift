public struct BaselineOffset: RichStringModifier {
    public typealias Body = Never

    public let offset: Double

    public init(_ offset: Double) {
        self.offset = offset
    }
}

public extension RichString {
    func baselineOffset(_ offset: Double) -> some RichString {
        modifier(BaselineOffset(offset))
    }
}
