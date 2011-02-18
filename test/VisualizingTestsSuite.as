package
{
    import animators.BaseAnimatorTest;
    import animators.ColorAnimatorTest;
    import animators.CrossfadeShaderAnimatorTest;
    import animators.NumericAnimatorTest;

    import visualizing.AnimationMapperTest;
    import visualizing.builder.VisualizerBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class VisualizingTestsSuite
    {
        // testing animators
        public var t1:BaseAnimatorTest;
        public var t2:NumericAnimatorTest;
        public var t3:ColorAnimatorTest;
        public var t4:CrossfadeShaderAnimatorTest;

        // testing visualizer
        public var t5:AnimationMapperTest;
        public var t6:VisualizerBuilderTest;
    }
}
