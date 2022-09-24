import Algorithms

public struct Join: RichString {
    let content: Concatenate

    public var body: some RichString { content }

    public init<Data, Separator, Content>(
        _ data: Data,
        separator: Separator,
        @RichStringBuilder content: (Data.Element) -> Content
    ) where Data: RandomAccessCollection, Separator: RichString, Content: RichString {
        let contents: [any RichString] = data.map(content)

        self.content = Concatenate(
            Array(contents.interspersed(with: separator))
        )
    }

    public init<Data, Separator, Content>(
        _ data: Data,
        @RichStringBuilder content: (Data.Element) -> Content,
        @RichStringBuilder separator: () -> Separator
    ) where Data: RandomAccessCollection, Separator: RichString, Content: RichString {
        let contents: [any RichString] = data.map(content)

        self.content = Concatenate(
            Array(contents.interspersed(with: separator()))
        )
    }
}
