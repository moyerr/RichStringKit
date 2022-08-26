import XCTest
@testable import RichStringKit

final class RichStringOutputTests: XCTestCase {
    private struct Fixture<Content: RichString>: RichString {
        @RichStringBuilder var content: () -> Content

        var body: some RichString {
            content()
        }
    }

    func testEmptyOutput() {
        let fixture = Fixture {}
        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(.empty)

        XCTAssertEqual(output, expected)
    }

    func testSingleStringOutput() {
        let fixture = Fixture { "Test" }
        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(.string("Test"))

        XCTAssertEqual(output, expected)
    }

    func testConcatenationOutput() {
        let fixture = Fixture {
            "Hello "
            "World!"
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .sequence([
                .string("Hello "),
                .string("World!")
            ])
        )

        XCTAssertEqual(output, expected)
    }

    func testSimpleModifiedOutput() {
        let fixture = Fixture {
            "Test"
                .foregroundColor(.blue)
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .modified(.string("Test"), .foregroundColor(.blue))
        )

        XCTAssertEqual(output, expected)
    }

    func testChainedModifiedOutput() {
        let fixture = Fixture {
            "Test"
                .foregroundColor(.white)
                .backgroundColor(.blue)
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .modified(
                .modified(.string("Test"), .foregroundColor(.white)),
                .backgroundColor(.blue)
            )
        )

        XCTAssertEqual(output, expected)
    }

    func testConcatenatedModifiedOutput() {
        let fixture = Fixture {
            "Test"
                .modifier(
                    BackgroundColor(.blue)
                        .concat(ForegroundColor(.white))
                )
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .modified(
                .string("Test"),
                .combined(.backgroundColor(.blue), .foregroundColor(.white))
            )
        )

        XCTAssertEqual(output, expected)
    }

    func testContatenatedModifiedOutput() {
        let fixture = Fixture {
            "Hello "
                .foregroundColor(.red)

            "World!"
                .foregroundColor(.blue)
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .sequence([
                .modified(.string("Hello "), .foregroundColor(.red)),
                .modified(.string("World!"), .foregroundColor(.blue))
            ])
        )

        XCTAssertEqual(output, expected)
    }

    func testComposedModifierOutput() {
        struct ForegroundAndBackground: RichStringModifier {
            let foreground: Color
            let background: Color
            func body(_ content: Content) -> some RichString {
                content
                    .foregroundColor(foreground)
                    .backgroundColor(background)
            }
        }

        let fixture = Fixture {
            "Test".modifier(
                ForegroundAndBackground(
                    foreground: .white,
                    background: .blue
                )
            )
        }

        let output = fixture._makeOutput()
        let expected: RichStringOutput = .init(
            .modified(
                .modified(.string("Test"), .foregroundColor(.white)),
                .backgroundColor(.blue)
            )
        )

        XCTAssertEqual(output, expected)
    }
}
