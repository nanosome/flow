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
        public function get states():Vector.<State> // TODO: Add caching to .state getter
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
                var targetsOfState:Vector.<State> = state.targets;
                var k:int = targetsOfState.length;
                var i:int;

                for (i = 0; i < k; i++)
                {
                    collectStates(result, targetsOfState[i]);
                }
            }
        }
        
        /**
         * Utility method, returning all transitions found in this StateMachine
         *
         * @return Vector of Transition objects
         */
        // TODO: add caching to .transitions getter
        public function get transitions():Vector.<Transition>
        {
            var result:Vector.<Transition> = new Vector.<Transition>();
            var states:Vector.<State> = this.states;
            var k:int = states.length;

            var i:int;

            for (i = 0; i < k; i++)
            {
                var transitions:Vector.<Transition> = states[i].transitions;
                var m:int = transitions.length;
                var j:int;
                for (j = 0; j < m; j++)
                {
                    if (result.indexOf(transitions[j]) < 0)
                        result.push(transitions[j]);
                }
            }
            return result;
        }

    }
}
