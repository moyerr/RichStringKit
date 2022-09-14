#if os(macOS)
import AppKit
typealias Image = NSImage
#else
import UIKit
typealias Image = UIImage
#endif

public struct Attachment: RichString {
    public typealias Body = Never
    public var body: Never { bodyAccessDisallowed() }

    #if os(macOS)
    public let image: NSImage

    public init(_ image: NSImage) {
        self.image = image
    }
    #else
    public let image: UIImage

    public init(_ image: UIImage) {
        self.image = image
    }
    #endif
}