package visualizing.builder.stateMachinesConfig
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

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
		
		override protected function configureStateMachine():StateMachine
		{
            var signals:NormalOveredSignals = getNewSignalsSet();

			fromNormalToOvered = _.
                from(normal).to(overed).by(signals.setOvered).
				back(fromOveredToNormal, signals.setNormal)._;
				
			return new StateMachine(normal);
		}

	}
}