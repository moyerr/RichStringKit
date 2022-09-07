#if os(macOS)
import AppKit
#else
import UIKit
#endif

import Foundation

private typealias Attributes = [NSAttributedString.Key: Any]

private extension NSUnderlineStyle {
    init(_ style: LineStyle) {
        switch style {
        case .single:               self = .single
        case .thick:                self = .thick
        case .double:               self = .double
        case .patternDot:           self = .patternDot
        case .patternDash:          self = .patternDash
        case .patternDashDot:       self = .patternDashDot
        case .patternDashDotDot:    self = .patternDashDotDot
        case .byWord:               self = .byWord
        }
    }
}

private extension RichStringOutput.Modifier {
    func makeAttributes() -> Attributes {
        switch self {
        case .backgroundColor(let color):
            return [.backgroundColor: color]
        case .baselineOffset(let offset):
            return [.baselineOffset: CGFloat(offset)]
        case .font(let font):
            return [.font: font]
        case .foregroundColor(let color):
            return [.foregroundColor: color]
        case .empty:
            return [:]
        case .kern(let value):
            return [.kern: NSNumber(value: value)]
        case .link(let url):
            return [.link: url]
        case .strikethroughStyle(let style):
            return [.strikethroughStyle: NSUnderlineStyle(style).rawValue]
        case .underlineColor(let color):
            return [.underlineColor: color]
        case .underlineStyle(let style):
            return [.underlineStyle: NSUnderlineStyle(style).rawValue]
        case .combined(let modifier1, let modifier2):
            return modifier1.makeAttributes()
                .merging(modifier2.makeAttributes()) { current, new in
                    new
                }
        }
    }
}

struct NSAttributedStringRenderer: RichStringRenderer {
    private struct RichStringReduction {
        struct AttributeMap {
            let range: Range<String.Index>
            let attributes: Attributes
        }

        var string: String = ""
        var attributeMaps: [AttributeMap] = []
    }

    static func render(_ component: some RichString) -> NSAttributedString {
        let output = component._makeOutput()

        guard case .content(let content) = output.storage else {
            return NSAttributedString()
        }

        let reduction = content.reduce(into: RichStringReduction()) { result, subContent in
            let nextPart = subContent
                .reduce(into: "") { currentString, subContent in
                    guard case .string(let str) = subContent else { return }
                    currentString += str
                }

            let currentEndIndex = result.string.endIndex
            let updatedString = result.string + nextPart

            switch subContent {
            case .modified(_, let modifier):
                let updatedEndIndex = updatedString.endIndex

                result.attributeMaps.append(.init(
                    range: currentEndIndex ..< updatedEndIndex,
                    attributes: modifier.makeAttributes())
                )
            case .string:
                result.string = updatedString
            default:
                break
            }
        }

        let attributedString = NSMutableAttributedString(string: reduction.string)

        for mapping in reduction.attributeMaps {
            attributedString.addAttributes(
                mapping.attributes,
                range: NSRange(mapping.range, in: reduction.string)
            )
        }

        return attributedString
    }
}

extension RichString {
    func render<Renderer: RichStringRenderer>(
        using rendererType: Renderer.Type
    ) -> Renderer.Result {
        Renderer.render(self)
    }
}

public extension NSAttributedString {
    convenience init(@RichStringBuilder _ content: () -> some RichString) {
        self.init(attributedString: .richString(content))
    }

    static func richString(
        @RichStringBuilder _ content: () -> some RichString
    ) -> NSAttributedString {
        content().render(using: NSAttributedStringRenderer.self)
    }
}
