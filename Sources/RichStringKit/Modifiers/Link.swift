import Foundation

public struct Link: RichStringModifier {
    public typealias Body = Never

    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.link(url))
    }
}

extension RichString {
    public func link(_ url: URL) -> some RichString {
        modifier(Link(url))
    }
}
