// @license@
package nanosome.flow.stateMachine
{
    import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.signals.Signal;
	import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.utils.ClassUtils;

    /**
	 * Suggestion is there'll be fairly small amount of StateMachines,
	 * so it makes sense to define them with separate classes, 
	 * to provide code hinting and type checking at early stage.
	 * 
	 * @see stateMachines.buttons.ButtonStateMachine
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilder 
	{
		private static const STATE_ID_PREFIX:String 	= "st.";

        private static var _stateMachine:StateMachine;

		private var _context:StateMachineBuilderContext;
        private var _backwardContext:StateMachineBuilderBackwardContext;

        /**
         * Please note, this method acts like singleton.
         * State machine initialization will take place only once.
         */
		public function StateMachineBuilder()
		{
            if (!_stateMachine)
            {
                initiateStates();
			    _stateMachine = configureStateMachine();
                checkTransitions();
            }
		}
		
		public function getStateMachine():StateMachine
		{
			return _stateMachine;
		}

        protected function configureStateMachine():StateMachine
        {
            throw new Error("This method should be overriden.");
        }

		//--------------------------------------------------------------------------
		//
		//  utility methods
		//
		//--------------------------------------------------------------------------

		private function initiateStates():void
		{
            var stateNames:Vector.<String> = ClassUtils.getVariablesOfType(this, State);

			for each (var stateName:String in stateNames)
			{
				this[stateName] = new State(STATE_ID_PREFIX + stateName);
			}
		}

        /**
         * Performs check if every transition was defined and is not null
         */
        private function checkTransitions():void
        {
            var transitionNames:Vector.<String> = ClassUtils.getVariablesOfType(this, Transition);
            var notDefinedTransitions:Array = [];
			for each (var transitionName:String in transitionNames)
			{
				if (this[transitionName] == null)
                    notDefinedTransitions.push("'" + transitionName + "'");
			}

            if (notDefinedTransitions.length > 0)
                throw new Error("Following transitions should be defined: " + notDefinedTransitions.join(", ") + ".");
        }
		
		//--------------------------------------------------------------------------
		//
		//  DSL specific methods
		//
		//--------------------------------------------------------------------------
/*
			fromNormalToOvered = _is(
				from(normal).to(overed).by(signals.mouseOver),
				backIs(fromOveredToNormal).by(signals.mouseOut)
			);
 */

		final public function from(state:State):StateMachineBuilder
		{
			_context = new StateMachineBuilderContext();
            _backwardContext = null;
			_context.sourceState = state;
			return this;
		}
		
		final public function by(signal:Signal):StateMachineBuilder
		{
			_context.signal = signal;
			checkExpression();
			return this;
		}

		final public function to(state:State):StateMachineBuilder
		{
			_context.targetState = state;
			checkExpression();
			return this;
		}

		final public function back(signal:Signal):void
		{
			_context.targetState.addTransition(signal.id, _context.sourceState);
		}			
		
		private function checkExpression():void
		{
			if (	_context && _context.sourceState && _context.signal && _context.targetState &&
					!_context.sourceState.hasTransitionForEvent(_context.signal.id)
				)
				_context.sourceState.addTransition(_context.signal.id, _context.targetState);
		}

        final public function backIs(backTransition:Transition):StateMachineBuilder
        {
            _backwardContext = new StateMachineBuilderBackwardContext();
            backTransition
            return this;
        }

        final public function _is(
                stateMachineBuilder:StateMachineBuilder,
                backStateMachineBuilder:StateMachineBuilder = null
                ):Transition
        {
            return null;
        }

	}
}
