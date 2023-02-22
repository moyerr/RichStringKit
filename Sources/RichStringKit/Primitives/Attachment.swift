#if os(macOS)
import AppKit
typealias Image = NSImage
#else
import UIKit
typealias Image = UIImage
#endif

@available(watchOS, unavailable)
public struct Attachment: RichString {
    public typealias Body = Never
    public var body: Never { bodyAccessDisallowed() }

    // swiftlint:disable type_contents_order
    #if os(macOS)
    public let image: NSImage

    public init(_ image: NSImage) {
        self.image = image
    }

    public init?(systemName: String) {
        guard let image = NSImage(
            systemSymbolName: systemName,
            accessibilityDescription: nil
        ) else {
            return nil
        }

        self.image = image
    }
    #else
    public let image: UIImage

    public init(_ image: UIImage) {
        self.image = image
    }

    public init?(systemName: String) {
        guard let image = UIImage(systemName: systemName) else { return nil }
        self.image = image
    }
    #endif
    // swiftlint:enable type_contents_order
}
