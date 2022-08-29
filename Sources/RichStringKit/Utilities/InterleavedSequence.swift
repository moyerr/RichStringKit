struct InterleavedSequence<First: Sequence, Second: Sequence>: Sequence where First.Element == Second.Element {
    let first: First
    let second: Second

    init(first: First, second: Second) {
        self.first = first
        self.second = second
    }

    func makeIterator() -> Iterator {
        Iterator(first: first.makeIterator(), second: second.makeIterator())
    }
}

extension InterleavedSequence {
    struct Iterator: IteratorProtocol {
        enum State { case first, second, exhausted }

        var first: First.Iterator
        var second: Second.Iterator
        var state = State.first

        mutating func next() -> First.Element? {
            switch state {
            case .first:
                guard let next = first.next() else {
                    state = .exhausted
                    return second.next()
                }

                state = .second
                return next
            case .second:
                guard let next = second.next() else {
                    state = .exhausted
                    return first.next()
                }
                state = .first
                return next
            case .exhausted:
                return first.next() ?? second.next()
            }
        }
    }
}

extension Sequence {
    func interleaved<S: Sequence>(with other: S) -> InterleavedSequence<Self, S> {
        InterleavedSequence(first: self, second: other)
    }
}
