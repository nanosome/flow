// @license@
package nanosome.flow.stateMachine
{
    /**
     * Due to implementation specific, <code>StateMachine</code> class consists
     * only of configured initial <code>State</code> and some methods to work with it.
     * Please note <code>State</code> objects in this implementation are stateful.
     */
    public class StateMachine
    {
        /**
         * @private
         * Holds configured initial <code>State<code> object.
         */
        private var _initialState:State;

        /**
         * @private
         * Holds a cache of collected <code>State<code> objects in this state machine.
         */
        private var _statesCache:Vector.<State>;

        /**
         * @private
         * Holds a cache of collected <code>Transition<code> objects in this state machine.
         */
        private var _transitionsCache:Vector.<Transition>;

        /**
         * Constructor.
         *  
         * @param initialState Initial state to start with.
         */
        public function StateMachine(initialState:State)
        {
            _initialState = initialState;
        }

        /**
         * Returns initial state for this state machine.
         * @return Initial <code>State</code>.
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
         * Checks if there is transition in this state machine for <code>state</code>
         * triggered by <code>Signal</code> with specified id.
         *
         * @param state State to be checked for transition.
         * @param signalID Signal id for specified <code>state</code>.
         * @return True, if transition exists, false otherwise.
         */
        public function hasTransitionFromStateForSignal(state:State, signalID:String):Boolean
        {
            return state.hasTransitionForSignal(signalID);
        }

        /**
         * Returns transition for <code>state</code> of this state machine
         * triggered by <code>Signal</code> with specified id.
         *
         * @param state State to be retrieved transition from.
         * @param signalID Signal id triggering transition.
         * @return Transition for <code>state</code> triggered by <code>signal</code> with id <code>signalID</code>.
         */
        public function getTransitionFromStateForSignal(state:State, signalID:String):Transition
        {
            return state.transitionForSignal(signalID);
        }

        /**
         * Adds new transition to this state machine.
         *
         * @param source Source state.
         * @param signalID Signal id triggering this transition.
         * @param target Target state.
         * @return New <code>Transition</code>
         */
        public function addTransition(source:State, signalID:String, target:State):Transition
        {
            return source.addTransition(signalID, target);
        }

        /**
         * Defines or redefines already existing transition for this state machine.
         *
         * @param transition Existing transition to be redefined.
         * @param source Source state.
         * @param signalID Signal id triggering transition.
         * @param target Target state.
         */
        public function defineTransition(transition:Transition, source:State, signalID:String, target:State):void
        {
            source.defineTransition(transition, signalID, target);
        }

        //--------------------------------------------------------------------------
        //
        //  Utility methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * Contains all states found in this <code>StateMachine</code>.
         * Uses internal caching mechanism to speed up the process.
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
         * @param result Vector.<State> with target states of <code>state</code>.
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
         * Contains all transitions found in this <code>StateMachine</code>.
         * Uses internal caching mechanism to speed up the process.
         *
         * @return Vector of Transition objects.
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
