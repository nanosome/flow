// @license@
package nanosome.flow.stateMachine
{
    public class StateMachine
    {
        /**
         * @private
         * Holds a set of all states
         */
        private var _initialState:State;

        private var _states:Vector.<State>;
        private var _transitions:Vector.<Transition>;

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

        public function hasTransitionFromStateForForEvent(state:State, signal:String):Boolean
        {
            return state.hasTransitionForEvent(signal);
        }

        public function getTransitionFromStateForEvent(state:State, signal:String):Transition
        {
            return state.transitionForEvent(signal);
        }

        public function addTransition(source:State, signal:String, target:State):Transition
        {
            return source.addTransition(signal, target);
        }

        public function defineTransition(transition:Transition, source:State, signal:String, target:State):void
        {
            source.defineTransition(transition, signal, target);
        }

        /**
         * Utility method, returning all states found in this StateMachine
         *
         * @return Array of State objects
         */
        public function get states():Vector.<State>
        {
            if (_states)
                return _states;
            _states = new Vector.<State>();
            collectStates(_states, getInitialState());
            return _states;
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
        public function get transitions():Vector.<Transition>
        {
            if (_transitions)
                return _transitions;

            _transitions = new Vector.<Transition>();
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
                    if (_transitions.indexOf(transitions[j]) < 0)
                        _transitions.push(transitions[j]);
                }
            }
            return _transitions;
        }

    }
}
