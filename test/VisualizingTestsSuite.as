package
{
    import animators.ColorAnimatorTest;
    import animators.NumericAnimatorTest;
    import visualizing.VisualizerTest;
    import visualizing.builder.VisualizerBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class VisualizingTestsSuite
    {
        // testing visualizing part
        public var t1:NumericAnimatorTest;
        public var t2:ColorAnimatorTest;
    }
}
