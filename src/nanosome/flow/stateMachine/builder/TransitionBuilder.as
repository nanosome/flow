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

        private var _backTransition:Transition;
		private var _backSignal:Signal;

        public function TransitionBuilder()
        {
        }

        public function get _():Transition
        {

        }

/*
            fromNormalToOvered = _.from(normal).to(overed).by(signals.mouseOver)._;
                _backIs(fromOveredToNormal).by(signals.mouseOut)
            );

            fromNormalToOvered = _.from(normal).to(overed).by(signals.mouseOver)
                                  .backIs(fromOveredToNormal).by(signals.mouseOut)._;
 */



		public function from(state:State):TransitionBuilder
		{
			//_context = new StateMachineBuilderContext();
            //_backwardContext = null;
			//_context.sourceState = state;
			return this;
		}

		public function by(signal:Signal):TransitionBuilder
		{
            /*
            if (_backwardContext == null)
            {
			    _context.signal = signal;
                checkExpression();
            }
            else
            {
                _backwardContext.signal = signal;
			}
			*/
			return this;
		}

		public function to(state:State):TransitionBuilder
		{
            /*
			_context.targetState = state;
			checkExpression();
            */
			return this;
		}

        public function back(backTransition:Transition, backSignal):TransitionBuilder
        {

        }

    }
}
