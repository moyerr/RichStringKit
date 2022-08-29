internal extension Collection {
    func split(
        maxSplits: Int = .max,
        omittingEmptySubsequences: Bool = true,
        whereSeparator isSeparator: (Index) throws -> Bool
    ) rethrows -> [SubSequence] {
        precondition(maxSplits >= 0, "Must take zero or more splits")

        var result: [SubSequence] = []
        var subSequenceStart: Index = startIndex

        func appendSubsequence(end: Index) -> Bool {
            if subSequenceStart == end && omittingEmptySubsequences {
                return false
            }
            result.append(self[subSequenceStart..<end])
            return true
        }

        if maxSplits == 0 || isEmpty {
            _ = appendSubsequence(end: endIndex)
            return result
        }

        var subSequenceEnd = subSequenceStart
        let cachedEndIndex = endIndex
        while subSequenceEnd != cachedEndIndex {
            if try isSeparator(subSequenceEnd) {
                let didAppend = appendSubsequence(end: subSequenceEnd)
                formIndex(after: &subSequenceEnd)
                subSequenceStart = subSequenceEnd
                if didAppend && result.count == maxSplits {
                    break
                }
                continue
            }
            formIndex(after: &subSequenceEnd)
        }

        if subSequenceStart != cachedEndIndex || !omittingEmptySubsequences {
            result.append(self[subSequenceStart..<cachedEndIndex])
        }

        return result
    }
}
