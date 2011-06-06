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

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        /**
         * Creates new StateMachine instance.
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
         * Checks if this state machine has a transition for given <code>State</code>
         * triggered by <code>Signal</code> with specified id.
         *
         * @param state State to be checked for transition.
         * @param signalID Signal id for specified <code>State</code>.
         * @return <code>true</code>, if transition exists, <code>false</code> otherwise.
         */
        public function hasTransitionFromStateForSignal(state:State, signalID:String):Boolean
        {
            return state.hasTransitionForSignal(signalID);
        }

        /**
         * Returns <code>Transition</code> for <code>State</code> of this state machine
         * triggered by <code>Signal</code> with specified id.
         *
         * @param state <code>State</code> to be retrieved transition from.
         * @param signalID id of the signal triggering transition.
         * @return Transition for <code>State</code> triggered by <code>Signal</code> with id <code>signalID</code>.
         */
        public function getTransitionFromStateForSignal(state:State, signalID:String):Transition
        {
            return state.transitionForSignal(signalID);
        }

        /**
         * Adds new transition to this state machine.
         *
         * @param source Source state.
         * @param signalID id for the signal triggering this transition.
         * @param target Target state.
         * @return New <code>Transition</code>.
         */
        public function addTransition(source:State, signalID:String, target:State):Transition
        {
            return source.addTransition(signalID, target);
        }

        /**
         * Defines or redefines already existing <code>Transition</code> for this state machine.
         *
         * @param transition Existing <code>Transition</code> to be redefined.
         * @param source New source state for specified <code>Transition</code>.
         * @param signalID Signal id for triggering this <code>Transition</code>.
         * @param target New target state for specified <code>Transition</code>.
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
         * Recursively collect all related states from <code>State</code> and adds them to <code>result</code>.
         * 
         * @param result <code>Vector.&lt;State&gt;</code> with target states of <code>State</code>.
         * @param state <code>State</code> to collect target states from.
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
         * Returns all transitions found in this <code>StateMachine</code>.
         * Uses internal caching mechanism to speed up the process.
         *
         * @return <code>Vector</code> of <code>Transition</code> objects.
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
