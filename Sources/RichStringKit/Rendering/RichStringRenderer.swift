protocol RichStringRenderer<Result> {
    associatedtype Result
    
    static func render(_ component: some RichString) -> Result
}
