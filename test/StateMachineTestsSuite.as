package
{
    import signals.SignalsLayerTest;
    import stateMachine.StateMachineTest;
    import stateMachine.builder.StateMachineBuilderTest;

    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class StateMachineTestsSuite
    {
        // testing StateMachine and its builder stuff
        public var t1:SignalsLayerTest;
        public var t2:StateMachineTest;
        public var t3:StateMachineBuilderTest;
    }
}
