protocol RichStringRenderer {
    associatedtype Result
    
    static func render(_ richString: some RichString) -> Result
}
