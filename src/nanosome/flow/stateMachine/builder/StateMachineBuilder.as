// @license@
package nanosome.flow.stateMachine.builder
{
    import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.utils.ClassUtils;

    /**
	 * Suggestion is there'll be fairly small amount of StateMachines,
	 * so it makes sense to define them with separate classes, 
	 * to provide code hinting and type checking at early stage.
     *
     * Each builder should be instantiated (and thus, having respective SM configured) only once.
     * In this code prevention from further instantiation is implemented via _isInstantiated static
     * variable. Statics aren't good, so I'm suggesting using factory for controlling
     * builders instantiation, leaving _isInstantiated check as a last resort.
	 *
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilder 
	{
        //----------------------------------
        //  Static constants and vars
        //----------------------------------

		private static const STATE_ID_PREFIX:String 	= "st.";

        //----------------------------------
        //  Regular class properties
        //----------------------------------

        private var _stateMachine:StateMachine;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

		public function StateMachineBuilder()
		{
            initiateStatesAndTransitions();
			_stateMachine = configureStateMachine();
            checkTransitions();
            validateStateMachine();
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

        /**
         * Performs state machine validation by collecting its states and transitions
         * and comparing them with states and transitions contained by this current builder.
         */
		private function validateStateMachine():void
		{
            var names:Vector.<String>;
            var name:String;
            var missingStates:Vector.<State> = new Vector.<State>();
            var missingTransitions:Vector.<Transition> = new Vector.<Transition>();

            var smStates:Vector.<State> = getStateMachine().states;
            var smTransitions:Vector.<Transition> = getStateMachine().transitions;

            names = ClassUtils.getVariablesOfType(this, State);
			for each (name in names)
			{
                if (smStates.indexOf(this[name]) < 0)
                    missingStates.push(this[name]);
			}

            names = ClassUtils.getVariablesOfType(this, Transition);
			for each (name in names)
			{
                if (smTransitions.indexOf(this[name]) < 0)
				    missingTransitions.push(this[name]);
			}
            
            if (missingStates.length > 0)
                throw new Error("State Machine has been built with errors, has missing States: " + missingStates);

            if (missingTransitions.length > 0)
                throw new Error("State Machine has been built with errors, has missing Transitions: " + missingTransitions);
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
