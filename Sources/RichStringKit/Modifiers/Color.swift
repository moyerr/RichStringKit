#if os(macOS)
import AppKit
typealias Color = NSColor
#else
import UIKit
typealias Color = UIColor
#endif

public struct ForegroundColor: RichStringModifier {
    public typealias Body = Never
    
    let color: Color

    init(_ color: Color) {
        self.color = color
    }
}

public struct BackgroundColor: RichStringModifier {
    public typealias Body = Never

    let color: Color

    init(_ color: Color) {
        self.color = color
    }
}

public extension RichString {
    #if os(macOS)
    func foregroundColor(_ color: NSColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: NSColor) -> some RichString {
        modifier(BackgroundColor(color))
    }
    #else
    func foregroundColor(_ color: UIColor) -> some RichString {
        modifier(ForegroundColor(color))
    }

    func backgroundColor(_ color: UIColor) -> some RichString {
        modifier(BackgroundColor(color))
    }
    #endif
}
