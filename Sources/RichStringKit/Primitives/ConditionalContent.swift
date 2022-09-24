public struct ConditionalContent<TrueContent, FalseContent>: RichString
    where TrueContent: RichString, FalseContent: RichString
{ // swiftlint:disable:this opening_brace
    public typealias Body = Never

    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    let storage: Storage

    public var body: Body { bodyAccessDisallowed() }
}
