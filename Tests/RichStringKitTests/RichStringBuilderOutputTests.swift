import XCTest
@testable import RichStringKit

final class RichStringBuilderOutputTests: XCTestCase {

    // MARK: - Content Tests

    func testEmptyStringOutput() {
        let output = EmptyString()._makeOutput()
        let expected = RichStringOutput(RichStringOutput.Content.empty)

        XCTAssertEqual(output, expected)
    }

    func testStringOutput() {
        let output = "Test"._makeOutput()
        let expected = RichStringOutput(.string("Test"))

        XCTAssertEqual(output, expected)
    }

    func testConcatenatedOutput() {
        let output = Concatenation([EmptyString(), "Test1", "Test2", EmptyString()])
            ._makeOutput()

        let expected = RichStringOutput(
            .sequence([.empty, .string("Test1"), .string("Test2"), .empty])
        )

        XCTAssertEqual(output, expected)
    }

    func testModifiedContentOutput() {
        let output = ModifiedContent(
            content: "Test",
            modifier: BaselineOffset(8)
        )._makeOutput()

        let expected = RichStringOutput(.modified(.string("Test"), .baselineOffset(8)))

        XCTAssertEqual(output, expected)
    }

    func testCustomRichStringOutput() {
        struct Fixture: RichString {
            var body: some RichString {
                "Hello"
                    .backgroundColor(.red)

                "World"
                    .kern(8)

                "!"
                    .baselineOffset(8)
            }
        }

        let output = Fixture()._makeOutput()
        let expected = RichStringOutput(
            .sequence([
                .modified(.string("Hello"), .backgroundColor(.red)),
                .modified(.string("World"), .kern(8)),
                .modified(.string("!"), .baselineOffset(8)),
            ])
        )

        XCTAssertEqual(output, expected)
    }

    // MARK: - Modifier Tests

    func testBackgroundColorOutput() {
        let output = BackgroundColor(.black)._makeOutput()
        let expected = RichStringOutput(.backgroundColor(.black))

        XCTAssertEqual(output, expected)
    }

    func testBaselineOffsetOutput() {
        let output = BaselineOffset(8)._makeOutput()
        let expected = RichStringOutput(.baselineOffset(8))

        XCTAssertEqual(output, expected)
    }

    func testFontOutput() {
        let output = _Font(.systemFont(ofSize: 45))._makeOutput()
        let expected = RichStringOutput(.font(.systemFont(ofSize: 45)))

        XCTAssertEqual(output, expected)
    }

    func testForegroundColorOutput() {
        let output = ForegroundColor(.red)._makeOutput()
        let expected = RichStringOutput(.foregroundColor(.red))

        XCTAssertEqual(output, expected)
    }

    func testEmptyModifierOutput() {
        let output = EmptyModifier()._makeOutput()
        let expected = RichStringOutput(RichStringOutput.Modifier.empty)

        XCTAssertEqual(output, expected)
    }

    func testKernOutput() {
        let output = Kern(8)._makeOutput()
        let expected = RichStringOutput(.kern(8))

        XCTAssertEqual(output, expected)
    }


    func testLinkOutput() {
        let url = URL(string: "http://www.example.com")!
        let output = Link(url)._makeOutput()
        let expected = RichStringOutput(.link(url))

        XCTAssertEqual(output, expected)
    }

    func testStrikethroughStyleOutput() {
        let output = StrikethroughStyle(.double)._makeOutput()
        let expected = RichStringOutput(.strikethroughStyle(.double))

        XCTAssertEqual(output, expected)
    }

    func testUnderlineColorOutput() {
        let output = UnderlineColor(.red)._makeOutput()
        let expected = RichStringOutput(.underlineColor(.red))

        XCTAssertEqual(output, expected)
    }

    func testUnderlineStyleOutput() {
        let output = UnderlineStyle(.double)._makeOutput()
        let expected = RichStringOutput(.underlineStyle(.double))

        XCTAssertEqual(output, expected)
    }

    func testModifiedContentModifierOutput() {
        let output = ModifiedContent(
            content: ForegroundColor(.white),
            modifier: BackgroundColor(.black)
        )._makeOutput()

        let expected = RichStringOutput(
            .combined(
                .foregroundColor(.white),
                .backgroundColor(.black)
            )
        )

        XCTAssertEqual(output, expected)
    }

    func testCustomModifierOutput() {
        struct Fixture: RichStringModifier {
            func body(_ content: Content) -> some RichString {
                content
                    .foregroundColor(.white)
                    .backgroundColor(.black)
            }
        }

        let output = Fixture()._makeOutput()
        let expected = RichStringOutput(
            .combined(
                .foregroundColor(.white),
                .backgroundColor(.black)
            )
        )

        XCTAssertEqual(output, expected)
    }

    func testEmptyCustomModifierOutput() {
        struct Fixture: RichStringModifier {
            func body(_ content: Content) -> some RichString {
                content
                // Pass content with no modifier
            }
        }

        let output = Fixture()._makeOutput()
        let expected = RichStringOutput(
            RichStringOutput.Modifier.empty
        )

        XCTAssertEqual(output, expected)
    }
}
