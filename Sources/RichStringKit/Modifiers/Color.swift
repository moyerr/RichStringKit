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

public extension RichString {
    #if os(macOS)
    func foregroundColor(_ color: NSColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: NSColor) -> some RichString {
        modifier(BackgroundColor(color))
    }

    func underlineColor(_ color: NSColor) -> some RichString {
        modifier(UnderlineColor(color))
    }
    #else
    func foregroundColor(_ color: UIColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: UIColor) -> some RichString {
        modifier(BackgroundColor(color))
    }

    func underlineColor(_ color: UIColor) -> some RichString {
        modifier(UnderlineColor(color))
    }
    #endif
}
