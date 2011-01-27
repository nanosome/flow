package
{
    import easing.EasingLineRunnerTest;
    import visualizing.VisualizerTest;
    import visualizing.builder.VisualizerBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class VisualizingTestsSuite
    {
        // testing visualizing part
        public var t1:EasingLineRunnerTest;
        public var t2:VisualizerTest;
        public var t3:VisualizerBuilderTest;
    }
}
