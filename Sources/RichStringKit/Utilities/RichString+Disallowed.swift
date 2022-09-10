extension RichString where Body == Never {
    func bodyAccessDisallowed() -> Never {
        fatalError("The 'body' property of primitive type '\(type(of: self)) should not be accessed directly.")
    }
}
