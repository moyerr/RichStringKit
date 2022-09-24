public struct ConditionalContent<TrueContent, FalseContent>: RichString where TrueContent: RichString, FalseContent: RichString {
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    let storage: Storage

    public typealias Body = Never
    public var body: Body { bodyAccessDisallowed() }
}
