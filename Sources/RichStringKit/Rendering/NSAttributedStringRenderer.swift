import Foundation

struct NSAttributedStringRenderer: RichStringRenderer {
    func render(_ component: some RichString) -> NSAttributedString {
        // TODO: Rendering
        NSAttributedString()
    }
}

extension RichString {
    func renderNSAttributedString() -> NSAttributedString {
        NSAttributedStringRenderer().render(self)
    }
}

