#if os(macOS)
import AppKit
typealias Color = NSColor
#else
import UIKit
typealias Color = UIColor
#endif

public struct BackgroundColor: RichStringModifier {
    public typealias Body = Never

    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.backgroundColor(color))
    }
}

public struct ForegroundColor: RichStringModifier {
    public typealias Body = Never

    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.foregroundColor(color))
    }
}

public struct UnderlineColor: RichStringModifier {
    public typealias Body = Never

    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.underlineColor(color))
    }
}

// MARK: Modifier Methods

extension RichString {
    #if os(macOS)
    public func foregroundColor(_ color: NSColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    public func backgroundColor(_ color: NSColor) -> some RichString {
        modifier(BackgroundColor(color))
    }

    public func underlineColor(_ color: NSColor) -> some RichString {
        modifier(UnderlineColor(color))
    }
    #else
    public func foregroundColor(_ color: UIColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    public func backgroundColor(_ color: UIColor) -> some RichString {
        modifier(BackgroundColor(color))
    }

    public func underlineColor(_ color: UIColor) -> some RichString {
        modifier(UnderlineColor(color))
    }
    #endif
}
