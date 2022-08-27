extension BidirectionalCollection {
    /// The range spanning all valid indices of the collection
    var rangeOfIndices: Range<Index> {
        startIndex ..< endIndex
    }
}
