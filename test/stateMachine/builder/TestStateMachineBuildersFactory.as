package stateMachine.builder
{
    import nanosome.flow.stateMachine.builders.StateMachineBuildersFactory;

    /**
     * Each StateMachineBuilder should be created / configured only once.
     * We're incapsulating and isolating this problem with StateMachineBuildersFactory.
     * It's up to developer to resolve it however he wants to - with IOC
     * or Singletons or somehow else.
     */
    public class TestStateMachineBuildersFactory extends StateMachineBuildersFactory
    {
        public var testStateMachineBuilder:TestStateMachineBuilder;
    }
}
