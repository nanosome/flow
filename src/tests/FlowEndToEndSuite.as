package tests
{
    import tests.signals.SignalsLayerTest;
    import tests.stateMachine.StateMachineTest;
    import tests.builder.StateMachineBuilderTest;
    import tests.visualizing.EasingLinesTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class FlowEndToEndSuite
    {
        // testing StateMachine and its builder stuff
        public var t1:SignalsLayerTest;
        public var t2:StateMachineTest;
        public var t3:StateMachineBuilderTest;

        // testing visualizing part
        public var t4:EasingLinesTest;
    }
}
