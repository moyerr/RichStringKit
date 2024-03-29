#if os(macOS)
import AppKit
#else
import UIKit
#endif

import Foundation

// MARK: - Rendering

enum NSAttributedStringRenderer: RichStringRenderer {
    fileprivate typealias Attributes = [NSAttributedString.Key: Any]

    private struct RangedAttributes {
        let range: Range<String.Index>
        let attributes: Attributes
    }

    static func render(_ richString: some RichString) -> NSAttributedString {
        guard let modifierMap = ModifierMap(from: richString) else {
            return NSAttributedString()
        }

        let finalString = modifierMap.string
        let attributesByRange = modifierMap.rangedModifiers
            .map { rangedModifier in
                RangedAttributes(
                    range: rangedModifier.range,
                    attributes: rangedModifier.modifier.makeAttributes()
                )
            }

        let attributedString = NSMutableAttributedString(string: finalString)

        for rangedAttributes in attributesByRange {
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: NSRange(rangedAttributes.range, in: finalString)
            )
        }

        return attributedString
    }
}

// MARK: - Type Conversions

extension RichStringOutput.Modifier {
    // swiftlint:disable:next cyclomatic_complexity
    fileprivate func makeAttributes() -> NSAttributedStringRenderer.Attributes {
        switch self {
        case .attachment(let image):
            #if os(macOS)
            let cell = NSTextAttachmentCell(imageCell: image)
            let attachment = NSTextAttachment()
            attachment.attachmentCell = cell
            return [.attachment: attachment]
            #elseif !os(watchOS)
            return [.attachment: NSTextAttachment(image: image)]
            #else
            return [:]
            #endif
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
            return [.kern: CGFloat(value)]
        case .link(let url):
            return [.link: url]
        case .strikethroughStyle(let style):
            return [.strikethroughStyle: NSUnderlineStyle(style).rawValue]
        case .underlineColor(let color):
            return [.underlineColor: color]
        case .underlineStyle(let style):
            return [.underlineStyle: NSUnderlineStyle(style).rawValue]
        case let .combined(modifier1, modifier2):
            return modifier1.makeAttributes()
                .merging(modifier2.makeAttributes()) { _, new in
                    new
                }
        }
    }
}

extension NSUnderlineStyle {
    fileprivate init(_ style: LineStyle) {
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
