public struct EmptyString: RichString {
    public typealias Body = Never
    public var body: Body { bodyAccessDisallowed() }
}
