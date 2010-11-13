// @license@
package nanosome.flow.stateMachine.builder
{
    import nanosome.flow.stateMachine.*;
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

        /**
         * Please note, this method acts like singleton.
         * State machine initialization will take place only once.
         */
		public function StateMachineBuilder()
		{
            if (!_stateMachine)
            {
                initiateStatesAndTransitions();
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

        /**
         * We need all states and transitions before constructing DSL expressions.
         * Unlike states, transitions will be instantiated, but not defined.
         */
		private function initiateStatesAndTransitions():void
		{
            var names:Vector.<String>;
            var name:String;

            names = ClassUtils.getVariablesOfType(this, State);
			for each (name in names)
			{
				this[name] = new State(STATE_ID_PREFIX + name);
			}

            names = ClassUtils.getVariablesOfType(this, Transition);
			for each (name in names)
			{
				this[name] = new Transition();
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
				if (!Transition(this[transitionName]).isDefined)
                    notDefinedTransitions.push("'" + transitionName + "'");
			}

            if (notDefinedTransitions.length > 0)
                throw new Error(
                        "Following transitions should be defined: " +
                        notDefinedTransitions.join(", ") +
                        "."
                );
        }
		
		//--------------------------------------------------------------------------
		//
		//  DSL specific methods
		//
		//--------------------------------------------------------------------------

        final public function get _():TransitionBuilder
        {
            return new TransitionBuilder();
        }
/*
		private function checkExpression():void
		{
			if (	_context && _context.sourceState && _context.signal && _context.targetState &&
					!_context.sourceState.hasTransitionForEvent(_context.signal.id)
				)
				_context.sourceState.addTransition(_context.signal, _context.targetState);
		}
*/
	}
}
