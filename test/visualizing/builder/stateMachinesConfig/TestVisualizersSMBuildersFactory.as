package visualizing.builder.stateMachinesConfig
{
    import stateMachine.builder.*;
    import nanosome.flow.stateMachine.builder.StateMachineBuildersFactory;

    import visualizing.builder.stateMachinesConfig.TestActivePassiveSM;

    /**
     * Each StateMachineBuilder should be created / configured only once.
     * We're incapsulating and isolating this problem with StateMachineBuildersFactory.
     * It's up to developer to resolve it however he wants to - with IOC
     * or Singletons or somehow else.
     */
    public class TestVisualizersSMBuildersFactory extends StateMachineBuildersFactory
    {
        public var testActivePassiveSMBuilder:TestActivePassiveSM;
        public var testNormalOveredSMBuilder:TestNormalOveredSM;
    }
}
