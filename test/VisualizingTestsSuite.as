package
{
    import animators.BaseAnimatorTest;
    import animators.ColorAnimatorTest;
    import animators.NumericAnimatorTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class VisualizingTestsSuite
    {
        // testing animators part
        public var t1:BaseAnimatorTest;
        public var t2:NumericAnimatorTest;
        public var t3:ColorAnimatorTest;
    }
}
