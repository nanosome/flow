package
{
    import animators.BaseAnimatorTest;
    import animators.ColorAnimatorTest;
    import animators.CrossfadeShaderAnimatorTest;
    import animators.NumericAnimatorTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class AnimatorsTestsSuite
    {
        // testing primary animators
        public var t1:BaseAnimatorTest;
        public var t2:NumericAnimatorTest;
        public var t3:ColorAnimatorTest;
        // test tricky shader-driven animator
        public var t4:CrossfadeShaderAnimatorTest;
    }
}
