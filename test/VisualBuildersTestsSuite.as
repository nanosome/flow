package
{
    import animators.BaseAnimatorTest;
    import animators.ColorAnimatorTest;
    import animators.CrossfadeShaderAnimatorTest;
    import animators.NumericAnimatorTest;

    import nanosome.flow.visualizing.builders.VisualMappingsStorageTest;

    import visualizing.AnimationMappingTest;
    import visualizing.VisualizerTest;
    import visualizing.builder.VisualMappingBuilderTest;
    import visualizing.builder.FlowBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class VisualBuildersTestsSuite
    {
        public var t1:VisualMappingsStorageTest;
        public var t2:VisualMappingBuilderTest;
        public var t3:FlowBuilderTest;
    }
}
