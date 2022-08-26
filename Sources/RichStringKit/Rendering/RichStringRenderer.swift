protocol RichStringRenderer<Result> {
    associatedtype Result
    
    func render(_ component: some RichString) -> Result
}
