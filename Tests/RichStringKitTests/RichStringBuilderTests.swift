@testable import RichStringKit
import XCTest

final class RichStringBuilderTests: XCTestCase {
    private struct Fixture<Content: RichString> {
        @RichStringBuilder var content: () -> Content
    }

    func testEmpty() {
        let content = Fixture { }.content()

        let actualType = type(of: content)
        let expectedType = EmptyString.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testSingleString() {
        let content = Fixture {
            "Test"
        }.content()

        let actualType = type(of: content)
        let expectedType = String.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testAttachment() {
        let content = Fixture {
            Attachment(.testImage)
        }.content()

        let actualType = type(of: content)
        let expectedType = Attachment.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testMultipleStrings() {
        let content = Fixture {
            "Hello"
            "World"
        }.content()

        let actualType = type(of: content)
        let expectedType = Concatenate.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testLooping() {
        let values = ["Hello", "Test", "World"]
        let content = Fixture {
            for value in values {
                value.kern(8)
            }
        }.content()

        let actualType = type(of: content)
        let expectedType = Concatenate.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testSingleModifier() {
        let content = Fixture {
            "Test"
                .foregroundColor(.blue)
        }.content()

        let actualType = type(of: content)
        let expectedType = ModifiedContent<String, ForegroundColor>.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testNestedModifiers() {
        let content = Fixture {
            "Test"
                .foregroundColor(.blue)
                .backgroundColor(.red)
        }.content()

        let actualType = type(of: content)
        let expectedType = ModifiedContent<ModifiedContent<String, ForegroundColor>, BackgroundColor>.self

        XCTAssertTrue(actualType == expectedType)
    }

    func testBuildEither() {
        let condition = true
        let content = Fixture {
            if condition {
                "Test"
            } else {
                EmptyString()
            }
        }.content()

        let actualType = type(of: content)
        let expectedType = ConditionalContent<String, EmptyString>.self

        XCTAssertTrue(actualType == expectedType)
    }
}
