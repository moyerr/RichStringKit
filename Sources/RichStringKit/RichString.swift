public protocol RichString {
    associatedtype Body
    @RichStringBuilder var body: Body { get }
}

public extension RichString {
    func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
