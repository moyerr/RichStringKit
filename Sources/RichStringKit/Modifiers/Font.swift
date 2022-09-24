#if os(macOS)
import AppKit
typealias Font = NSFont
#else
import UIKit
typealias Font = UIFont
#endif

public struct _Font: RichStringModifier {
    public typealias Body = Never

    let font: Font

    init(_ font: Font) {
        self.font = font
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.font(font))
    }
}

extension RichString {
    #if os(macOS)
    public func font(_ font: NSFont) -> some RichString {
        modifier(_Font(font))
    }
    #else
    public func font(_ font: UIFont) -> some RichString {
        modifier(_Font(font))
    }
    #endif
}
