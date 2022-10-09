import Foundation

extension NSAttributedString {
    public convenience init(@RichStringBuilder _ content: () -> some RichString) {
        self.init(attributedString: .richString(content))
    }

    public convenience init(_ content: some RichString) {
        self.init(attributedString: .richString(content))
    }

    public static func richString(
        @RichStringBuilder _ content: () -> some RichString
    ) -> NSAttributedString {
        content().render(using: NSAttributedStringRenderer.self)
    }

    public static func richString(_ content: some RichString) -> NSAttributedString {
        content.render(using: NSAttributedStringRenderer.self)
    }
}
