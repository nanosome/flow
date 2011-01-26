// @license@
package nanosome.flow.stateMachine
{
	import nanosome.flow.stateMachine.logic.State;
	
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
        public function getStates():Array
        {
            var result:Array = [];
            collectStates(result, getInitialState());
            return result;
        }

        private function collectStates(result:Array, state:State):void
        {
            if (result.indexOf(state) >= 0) return;
            result.push(state);
            var targetsOfState:Array = state.getAllTargets();
            for each (var s:State in targetsOfState)
            {
                collectStates(result, s);
            }
        }

	}
}
