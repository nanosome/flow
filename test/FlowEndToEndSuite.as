package
{
    import signals.SignalsLayerTest;
    import stateMachine.StateMachineTest;
    import builder.StateMachineBuilderTest;
    import easing.EasingLinesTest;

    import signals.SignalsLayerTest;

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
