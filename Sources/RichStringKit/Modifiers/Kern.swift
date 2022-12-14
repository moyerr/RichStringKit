public struct Kern: RichStringModifier {
    public typealias Body = Never

    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.kern(value))
    }
}

extension RichString {
    public func kern(_ value: Double) -> some RichString {
        modifier(Kern(value))
    }
}
