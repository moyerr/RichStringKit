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

    func testAttachmentOutput() {
        let output = Attachment(.testImage)._makeOutput()
        let expected = RichStringOutput(.modified(.attachment, .attachment(.testImage)))

        XCTAssertEqual(output, expected)
    }

    func testConcatenateOutput() {
        let output = Concatenate(EmptyString(), "Test1", "Test2", EmptyString())
            ._makeOutput()

        let expected = RichStringOutput(
            .sequence([.empty, .string("Test1"), .string("Test2"), .empty])
        )

        XCTAssertEqual(output, expected)
    }

    func testConditionalContentOutput() {
        let trueContent = "Test".kern(8)
        let falseContent = EmptyString()

        let outputTrue = ConditionalContent<_, EmptyString>(
            storage: .trueContent(trueContent)
        )._makeOutput()

        let outputFalse = ConditionalContent<ModifiedContent<String, Kern>, _>(
            storage: .falseContent(falseContent)
        )._makeOutput()

        let expectedTrue = RichStringOutput(.modified(.string("Test"), .kern(8)))
        let expectedFalse = RichStringOutput(RichStringOutput.Content.empty)

        XCTAssertEqual(outputTrue, expectedTrue)
        XCTAssertEqual(outputFalse, expectedFalse)
    }

    func testFormatOutput() {
        let output0 = Format("%@", "Test")._makeOutput()
        let output1 = Format("%@%@", "Test", "Again")._makeOutput()
        let output2 = Format("Hello %@!", "Test")._makeOutput()
        let output3 = Format("%@ is a %@", "This", "Test")._makeOutput()
        let output4 = Format("", "Test")._makeOutput()

        let expected0 = RichStringOutput(.sequence([.string("Test")]))
        let expected1 = RichStringOutput(.sequence([.string("Test"), .string("Again")]))
        let expected2 = RichStringOutput(.sequence([
            .string("Hello "),
            .string("Test"),
            .string("!")
        ]))
        let expected3 = RichStringOutput(.sequence([
            .string("This"),
            .string(" is a "),
            .string("Test")
        ]))
        let expected4 = RichStringOutput(.sequence([]))

        XCTAssertEqual(output0, expected0)
        XCTAssertEqual(output1, expected1)
        XCTAssertEqual(output2, expected2)
        XCTAssertEqual(output3, expected3)
        XCTAssertEqual(output4, expected4)
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

    func testLoopedContentOutput() {
        struct Fixture: RichString {
            let values = ["Hello", "Test", "World"]
            var body: some RichString {
                for value in values {
                    value.kern(8)
                }
            }
        }

        let output = Fixture()._makeOutput()
        let expected = RichStringOutput(
            .sequence([
                .modified(.string("Hello"), .kern(8)),
                .modified(.string("Test"), .kern(8)),
                .modified(.string("World"), .kern(8))
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
