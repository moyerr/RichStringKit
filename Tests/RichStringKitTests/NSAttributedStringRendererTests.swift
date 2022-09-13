//
//  NSAttributedStringRendererTests.swift
//  
//
//  Created by Robert Moyer on 9/13/22.
//

@testable import RichStringKit
import XCTest

final class NSAttributedStringRendererTests: XCTestCase {
    private struct Fixture<Content: RichString>: RichString {
        @RichStringBuilder var content: () -> Content
        var body: some RichString { content() }
    }

    // MARK: - Primitives

    func testEmpyString() {
        let richString = EmptyString()

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString()

        XCTAssertEqual(actual, expected)
    }

    func testString() {
        let richString = "Test"

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(string: "Test")

        XCTAssertEqual(actual, expected)
    }

    func testConcatenate() {
        let richString = Concatenate("Hello ", EmptyString(), "World", "!!!", EmptyString())

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(string: "Hello World!!!")

        XCTAssertEqual(actual, expected)
    }

    func testModifiedContent() {
        let richString = ModifiedContent(
            content: "Test",
            modifier: BaselineOffset(8)
        )

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(
            string: "Test",
            attributes: [.baselineOffset: CGFloat(8)]
        )

        XCTAssertEqual(actual, expected)
    }

    func testNestedContentModifiedContent() {
        let richString = ModifiedContent(
            content: ModifiedContent(
                content: "Test",
                modifier: BaselineOffset(8)
            ),
            modifier: Kern(8)
        )

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(
            string: "Test",
            attributes: [
                .baselineOffset: CGFloat(8),
                .kern: CGFloat(8)
            ]
        )

        XCTAssertEqual(actual, expected)
    }

    func testNestedModifierModifiedContent() {
        let richString = ModifiedContent(
            content: "Test",
            modifier: ModifiedContent(
                content: BaselineOffset(8),
                modifier: Kern(8)
            )
        )

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(
            string: "Test",
            attributes: [
                .baselineOffset: CGFloat(8),
                .kern: CGFloat(8)
            ]
        )

        XCTAssertEqual(actual, expected)
    }

    // MARK: - Compositions

    func testGroupedModifiedContent() {
        let richString = Fixture {
            Group {
                "Test".baselineOffset(8)
            }.kern(8)
        }

        let actual = NSAttributedString(richString)
        let expected = NSAttributedString(
            string: "Test",
            attributes: [
                .baselineOffset: CGFloat(8),
                .kern: CGFloat(8)
            ]
        )

        XCTAssertEqual(actual, expected)
    }

    func testGroupedConcatenatedModifiedContent() throws {
        let rawString = "Hello World!!!"
        let richString = Fixture {
            Group {
                "Hello"
                    .underlineStyle(.single)

                " "

                "World"
                    .underlineStyle(.double)
                    .strikethroughStyle(.single)

                "!!!"
                    .baselineOffset(8)
            }.kern(8)
        }

        let actual = NSAttributedString(richString)

        let helloRange = try XCTUnwrap(rawString.range(of: "Hello"))
        let worldRange = try XCTUnwrap(rawString.range(of: "World"))
        let punctuationRange = try XCTUnwrap(rawString.range(of: "!!!"))

        let expected = NSMutableAttributedString(
            string: "Hello World!!!",
            attributes: [.kern: CGFloat(8)]
        )

        expected.addAttributes(
            [.underlineStyle: NSUnderlineStyle.single.rawValue],
            range: NSRange(helloRange, in: rawString)
        )

        expected.addAttributes(
            [.underlineStyle: NSUnderlineStyle.double.rawValue, .strikethroughStyle: NSUnderlineStyle.single.rawValue],
            range: NSRange(worldRange, in: rawString)
        )

        expected.addAttributes(
            [.baselineOffset: CGFloat(8)],
            range: NSRange(punctuationRange, in: rawString)
        )

        XCTAssertEqual(actual, expected)
    }
}
