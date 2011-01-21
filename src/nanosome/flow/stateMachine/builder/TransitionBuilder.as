package nanosome.flow.stateMachine.builder
{
    import nanosome.flow.signals.Signal;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    final public class TransitionBuilder
    {
        private var _sourceState:State;
		private var _signal:Signal;
		private var _targetState:State;

        public function TransitionBuilder() {}

        public function get _():Transition
        {
            checkTransition();
            return _sourceState.addTransition(_signal, _targetState);
        }

/*
            fromNormalToOvered = _.from(normal).to(overed).by(signals.mouseOver)._;

            fromNormalToOvered = _.from(normal).to(overed).by(signals.mouseOver)
                                  .back(fromOveredToNormal, signals.mouseOut)._;
 */

		public function from(state:State):TransitionBuilder
		{
			_sourceState = state;
			return this;
		}

		public function by(signal:Signal):TransitionBuilder
		{
            _signal = signal;
			return this;
		}

		public function to(state:State):TransitionBuilder
		{
			_targetState = state;
			return this;
		}

        private function checkTransition():void
        {
            if (!_sourceState)
                throw new Error("Source state is not defined!");

            if (!_targetState)
                throw new Error("Target state is not defined!");

            if (!_signal)
                throw new Error("Signal for transition is not defined!");
        }

        public function back(backTransition:Transition, backSignal:Signal):TransitionBuilder
        {
            checkTransition();
            _targetState.defineTransition(backTransition, backSignal, _sourceState);
            return this;
        }

    }
}
