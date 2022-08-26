import XCTest
@testable import RichStringKit

final class NSAttributedStringRendererTests: XCTestCase {
    private struct Fixture<Content: RichString>: RichString {
        @RichStringBuilder var content: () -> Content

        var body: some RichString {
            content()
        }
    }
}
