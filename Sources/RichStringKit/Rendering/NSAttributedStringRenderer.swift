import Foundation

private typealias Attribute = (NSAttributedString.Key, Any)
private extension RichStringOutput.Modifier {
    func makeAttributes() -> [Attribute] {
        switch self {
        case .backgroundColor(let color):
            return [(.backgroundColor, color)]
        case .baselineOffset(let offset):
            return [(.baselineOffset, CGFloat(offset))]
        case .foregroundColor(let color):
            return [(.foregroundColor, color)]
        case .combined(let modifier1, let modifier2):
            return modifier1.makeAttributes() + modifier2.makeAttributes()
        }
    }
}

struct NSAttributedStringRenderer: RichStringRenderer {
    private struct RichStringReduction {
        struct AttributeMapping {
            let range: Range<String.Index>
            let attributes: [Attribute]
        }

        var string: String = ""
        var attributeMapping: [AttributeMapping] = []
    }

    func render(_ component: some RichString) -> NSAttributedString {
        let output = component._makeOutput()

        guard case .content(let content) = output.storage else {
            return NSAttributedString()
        }

        var reduction = RichStringReduction()
        reduce(content, into: &reduction)

        let string = NSMutableAttributedString(string: reduction.string)

        for mapping in reduction.attributeMapping {
            let attributes = mapping.attributes
                .reduce(into: [NSAttributedString.Key: Any]()) { partialResult, attribute in
                    partialResult[attribute.0] = attribute.1
                }

            string.addAttributes(attributes, range: NSRange(mapping.range, in: reduction.string))
        }

        return string
    }

    @discardableResult
    private func reduce(
        _ content: RichStringOutput.Content,
        into string: inout String
    ) -> Substring {
        let currentEndIndex = string.endIndex

        switch content {
        case .empty:
            break
        case .string(let newString):
            string += newString
        case .modified(let content, _):
            reduce(content, into: &string)
        case .sequence(let contents):
            for content in contents {
                reduce(content, into: &string)
            }
        }

        return string[currentEndIndex...]
    }

    private func reduce(
        _ content: RichStringOutput.Content,
        into reduction: inout RichStringReduction
    ) {
        var currentString = reduction.string
        let substring = reduce(content, into: &currentString)

        switch content {
        case .modified(let content, let modifier):
            reduction.attributeMapping.append(.init(
                range: substring.rangeOfIndices,
                attributes: modifier.makeAttributes())
            )

            reduce(content, into: &reduction)
        case .sequence(let contents):
            for nestedContent in contents {
                reduce(nestedContent, into: &reduction)
            }
        default:
            reduction.string += substring
        }
    }
}

public extension RichString {
    func renderNSAttributedString() -> NSAttributedString {
        NSAttributedStringRenderer().render(self)
    }
}
