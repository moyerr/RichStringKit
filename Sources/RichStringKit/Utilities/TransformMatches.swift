// swiftlint:disable:this file_name
import Foundation

#if canImport(_StringProcessing)
@available(iOS 16, tvOS 16, watchOS 9, macOS 13, *)
extension BidirectionalCollection where SubSequence == Substring {
    func transformMatches<Output, Transformed>(
        of regex: some RegexComponent<Output>,
        using transform: (Regex<Output>.Match, Int) throws -> Transformed,
        transformNonMatches: (SubSequence) throws -> Transformed
    ) rethrows -> [Transformed] {
        if isEmpty { return [] }

        let matches = matches(of: regex)

        var result: [Transformed] = []
        var subSequenceStart: Index = startIndex

        func appendSubsequence(end: Index) throws {
            if subSequenceStart == end { return }
            let transformed = try transformNonMatches(self[subSequenceStart ..< end])
            result.append(transformed)
        }

        for (index, match) in matches.enumerated() {
            try appendSubsequence(end: match.range.lowerBound)
            result.append(try transform(match, index))
            subSequenceStart = match.range.upperBound
        }

        try appendSubsequence(end: endIndex)

        return result
    }
}
#endif

extension String {
    func transformMatches<Transformed>(
        of regex: NSRegularExpression,
        using transform: (NSTextCheckingResult, Int) throws -> Transformed,
        transformNonMatches: (SubSequence) throws -> Transformed
    ) rethrows -> [Transformed] {
        if isEmpty { return [] }

        let matches = regex.matches(
            in: self,
            range: NSRange(startIndex ..< endIndex, in: self)
        )

        var result: [Transformed] = []
        var subSequenceStart: Index = startIndex

        func appendSubsequence(end: Index) throws {
            if subSequenceStart == end { return }
            let transformed = try transformNonMatches(self[subSequenceStart ..< end])
            result.append(transformed)
        }

        for (index, match) in matches.enumerated() {
            guard let range = Range(match.range, in: self) else { continue }

            try appendSubsequence(end: range.lowerBound)
            result.append(try transform(match, index))
            subSequenceStart = range.upperBound
        }

        try appendSubsequence(end: endIndex)

        return result
    }
}
