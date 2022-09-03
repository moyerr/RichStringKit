public protocol RichString {
    associatedtype Body: RichString

    func _makeOutput() -> RichStringOutput
    @RichStringBuilder var body: Body { get }
}

extension RichString where Body == Never {
    public var body: Body {
        // Trap
        preconditionFailure("Body of primitive content \(String(describing: Self.self)) should not be accessed")
    }
}

public extension RichString {
    func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }
}

