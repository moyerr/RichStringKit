@available(iOS 16, tvOS 16, watchOS 9, macOS 13, *)
extension BidirectionalCollection where SubSequence == Substring {
    func transformMatches<Output, Transformed>(
        of r: some RegexComponent<Output>,
        using transform: (Regex<Output>.Match, Int) throws -> Transformed,
        transformNonMatches: (SubSequence) throws -> Transformed
    ) rethrows -> [Transformed] {
        if isEmpty { return [] }

        let matches = matches(of: r)

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
