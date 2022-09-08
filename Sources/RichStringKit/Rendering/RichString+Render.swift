extension RichString {
    func render<Renderer: RichStringRenderer>(
        using rendererType: Renderer.Type
    ) -> Renderer.Result {
        Renderer.render(self)
    }
}
