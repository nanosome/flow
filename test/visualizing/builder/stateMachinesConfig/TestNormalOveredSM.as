package visualizing.builder.stateMachinesConfig
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    import misc.ButtonSignals;

    public class TestNormalOveredSM extends StateMachineBuilder
    {
        // states
        public var normal:State;
        public var overed:State;

        // transitions
        public var fromNormalToOvered:Transition;
        public var fromOveredToNormal:Transition;

        public function getNewSignalsSet():NormalOveredSignals
        {
            return new NormalOveredSignals();
        }

        override protected function configureStateMachine():void
        {
            var signals:NormalOveredSignals = getNewSignalsSet();

            initialState = normal;

            fromNormalToOvered = _.
                from(normal).to(overed).by(signals.setOvered).
                back(fromOveredToNormal, signals.setNormal)._;
        }

    }
}
