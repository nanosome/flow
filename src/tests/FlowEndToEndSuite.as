package tests
{
    import tests.signals.SignalsLayerTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class FlowEndToEndSuite
    {
        public var t1:SignalsLayerTest;
        public var t2:SMSemanticTest;
    }
}
