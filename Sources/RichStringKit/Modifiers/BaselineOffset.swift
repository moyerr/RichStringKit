public struct BaselineOffset: RichStringModifier {
    public typealias Body = Never

    let offset: Double

    init(_ offset: Double) {
        self.offset = offset
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.baselineOffset(offset))
    }
}

public extension RichString {
    func baselineOffset(_ offset: Double) -> some RichString {
        modifier(BaselineOffset(offset))
    }
}
