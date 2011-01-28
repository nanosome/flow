// @license@
package nanosome.flow.stateMachine
{
	import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    public class StateMachine
	{
		/**
		 * @private
		 * Holds a set of all states
		 */
		private var _initialState:State;

		/**
		 * Constructor
		 *  
		 * @param initialState Initial state to start with
		 */			
		public function StateMachine(initialState:State)
		{
			_initialState = initialState;
		}

        public function getInitialState():State
        {
            return _initialState;
        }

        /**
         * Utility method, returning all states found in this StateMachine
         *
         * @return Array of State objects
         */
        public function getStates():Vector.<State>
        {
            var result:Vector.<State> = new Vector.<State>();
            collectStates(result, getInitialState());
            return result;
        }

        private function collectStates(result:Vector.<State>, state:State):void
        {
            if (result.indexOf(state) == -1)
            {
                result.push(state);
                var targetsOfState:Vector.<State> = state.getAllTargets();
                for each (var s:State in targetsOfState)
                {
                    collectStates(result, s);
                }
            }
        }
        
        /**
         * Utility method, returning all transitions found in this StateMachine
         *
         * @return Array of Transition objects
         */
        public function getTransitions():Vector.<Transition>
        {
            var result:Vector.<Transition> = new Vector.<Transition>();
            var states:Vector.<State> = getStates();
            var state:State;
            var transitions:Vector.<Transition>;
            var transition:Transition;

            for each (state in states)
            {
                transitions = state.getAllTransitions();
                for each (transition in transitions)
                {
                    if (result.indexOf(transition) < 0)
                        result.push(transition);
                }
            }
            return result;
        }
        
	}
}
