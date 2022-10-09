public protocol RichString {
    associatedtype Body: RichString

    @RichStringBuilder var body: Body { get }

    func _makeOutput() -> RichStringOutput
}

extension RichString {
    public func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
