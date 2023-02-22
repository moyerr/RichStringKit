import Foundation

public struct RichStringOutput: Equatable {
    enum Modifier: Equatable {
        case backgroundColor(Color)
        case baselineOffset(Double)
        case empty
        case font(Font)
        case foregroundColor(Color)
        case kern(Double)
        case link(URL)
        case strikethroughStyle(LineStyle)
        case underlineColor(Color)
        case underlineStyle(LineStyle)
        case paragraphStyle(ParagraphStyle)

        @available(watchOS, unavailable)
        case attachment(Image)

        indirect case combined(Modifier, Modifier)
    }

    enum Content: Equatable {
        case empty
        case string(String)
        case attachment
        indirect case modified(Content, Modifier)
        indirect case sequence([Content])
    }

    enum Storage: Equatable {
        case content(Content)
        case modifier(Modifier)
    }

    let storage: Storage

    var content: Content {
        guard case .content(let value) = storage else {
            fatalError("Storage was not content")
        }

        return value
    }

    init(_ content: Content) {
        self.storage = .content(content)
    }

    init(_ modifier: Modifier) {
        self.storage = .modifier(modifier)
    }
}

extension RichStringOutput.Content {
    func reduce<Result>(
        into initialResult: Result,
        _ updateAccumulatingResult: (inout Result, Self) throws -> Void
    ) rethrows -> Result {
        var accumulator = initialResult
        try updateAccumulatingResult(&accumulator, self)

        switch self {
        case .modified(let content, _):
            accumulator = try content.reduce(into: accumulator, updateAccumulatingResult)
        case .sequence(let contents):
            for content in contents {
                accumulator = try content.reduce(into: accumulator, updateAccumulatingResult)
            }
        default:
            break
        }

        return accumulator
    }

    func reduceIntoFinalString() -> String {
        reduce(into: "") { result, subContent in
            switch subContent {
            case .string(let string):
                result += string
            case .attachment:
                // Object Replacement Character
                result += "\u{FFFC}"
            default:
                return
            }
        }
    }
}
