package tests
{
    import tests.signals.SignalsLayerTest;
    import tests.stateMachine.StateMachineTest;
    import tests.builder.StateMachineBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class FlowEndToEndSuite
    {
        public var t1:SignalsLayerTest;
        public var t2:StateMachineTest;
        public var t3:StateMachineBuilderTest;
    }
}
