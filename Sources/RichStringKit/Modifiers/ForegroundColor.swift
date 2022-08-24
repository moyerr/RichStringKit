#if os(macOS)
import AppKit
typealias Color = NSColor
#else
import UIKit
typealias Color = UIColor
#endif

struct ForegroundColor: RichStringModifier {
    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    func modify(_ content: Content) -> some RichString {
        return ModifiedContent(content: content, modifier: self)
    }
}

struct BackgroundColor: RichStringModifier {
    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    func modify(_ content: Content) -> some RichString {
        return ModifiedContent(content: content, modifier: self)
    }
}

public extension RichString {
    #if os(macOS)
    func foregroundColor(_ color: NSColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: NSColor) -> some RichString {
        modifier(ForegroundColor(color))
    }
    #else
    func foregroundColor(_ color: UIColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: UIColor) -> some RichString {
        modifier(ForegroundColor(color))
    }
    #endif
}
