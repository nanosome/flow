// @license@
package nanosome.flow.stateMachine
{
    /**
     * StateMachine class contains only configured initial <code>State</code> and some methods to work with it.
     * Please note <code>State</code> objects in this implementation are stateful.
     */
    public class StateMachine
    {
        /**
         * @private
         * Holds configured initial <code>State<code> object
         */
        private var _initialState:State;

        /**
         * @private
         * Holds a cache of collected <code>State<code> objects in this state machine
         */
        private var _statesCache:Vector.<State>;

        /**
         * @private
         * Holds a cache of collected <code>Transition<code> objects in this state machine
         */
        private var _transitionsCache:Vector.<Transition>;

        /**
         * Constructor
         *  
         * @param initialState Initial state to start with
         */
        public function StateMachine(initialState:State)
        {
            _initialState = initialState;
        }

        /**
         * @return Initial state for this state machine
         */
        public function getInitialState():State
        {
            return _initialState;
        }

        //--------------------------------------------------------------------------
        //
        //  Construction methods
        //
        //--------------------------------------------------------------------------

        /**
         * Checks if there is transition in this state machine for <code>state</code> on <code>signal</code>.
         *
         * @param state State to be checked for transition
         * @param signal Signal <code>state</code> will be checked with
         * @return True, if transition exists in this state machine for specified state an signal, false otherwise.
         */
        public function hasTransitionFromStateForForEvent(state:State, signal:String):Boolean
        {
            return state.hasTransitionForSignal(signal);
        }

        /**
         * Returns transition for <code>state</code> of this state machine triggered by <code>signal</code>.
         *
         * @param state State to be retrieved transition from
         * @param signal Signal for transition
         * @return Transition for <code>state</code> triggered by <code>signal</code>
         */
        public function getTransitionFromStateForEvent(state:State, signal:String):Transition
        {
            return state.transitionForSignal(signal);
        }

        /**
         * Adds new transition to this state machine.
         *
         * @param source Source state
         * @param signal Signal triggering this transition
         * @param target Target state
         * @return New <code>Transition</code>
         */
        public function addTransition(source:State, signal:String, target:State):Transition
        {
            return source.addTransition(signal, target);
        }

        /**
         * Defines or redefines already existing transition in this state machine.
         *
         * @param transition Existing transition to be redefined
         * @param source Source state
         * @param signal Signal triggering transition
         * @param target Target state
         */
        public function defineTransition(transition:Transition, source:State, signal:String, target:State):void
        {
            source.defineTransition(transition, signal, target);
        }

        //--------------------------------------------------------------------------
        //
        //  Utility methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * Utility method, returning all states found in this StateMachine.
         * Uses cache variable <code>_statesCache</code> to speed up the process.
         * 
         * @return Vector of <code>State</code> objects
         */
        public function get states():Vector.<State>
        {
            if (_statesCache)
                return _statesCache;
            _statesCache = new Vector.<State>();
            collectStates(_statesCache, getInitialState());
            return _statesCache;
        }

        /**
         * Recursively collect all related states from <code>state</code> and adds them to <code>result</code>.
         * 
         * @param result Vector.<State> with target states of <code>state</code>
         * @param state State to collect target states from.
         */
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
         * Utility method, returning all transitions found in this StateMachine.
         * Uses cache variable <code>_transitionsCache</code> to speed up the process.
         *
         * @return Vector of Transition objects
         */
        public function get transitions():Vector.<Transition>
        {
            if (_transitionsCache)
                return _transitionsCache;

            _transitionsCache = new Vector.<Transition>();
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
                    if (_transitionsCache.indexOf(transitions[j]) < 0)
                        _transitionsCache.push(transitions[j]);
                }
            }
            return _transitionsCache;
        }

    }
}
