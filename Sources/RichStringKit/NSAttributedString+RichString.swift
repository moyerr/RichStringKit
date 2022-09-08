import Foundation

public extension NSAttributedString {
    convenience init(@RichStringBuilder _ content: () -> some RichString) {
        self.init(attributedString: .richString(content))
    }

    convenience init(_ content: some RichString) {
        self.init(attributedString: .richString(content))
    }

    static func richString(
        @RichStringBuilder _ content: () -> some RichString
    ) -> NSAttributedString {
        content().render(using: NSAttributedStringRenderer.self)
    }

    static func richString(_ content: some RichString) -> NSAttributedString {
        content.render(using: NSAttributedStringRenderer.self)
    }
}
