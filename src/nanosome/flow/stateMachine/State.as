// @license@
package nanosome.flow.stateMachine
{
    import flash.utils.Dictionary;

    /**
     *  State object for the StateMachine class.
     *  Each <code>State</code> instance contains list of adjacent transitions,
     *  therefore each <code>State</code> object is stateful and unique.
     *  Please pay attention to it.
     *  
     *  @see StateMachine
     *  @author dimitri.fedorov
     */
    public class State
    {
        /**
         * @private 
         * Holds the id for this state.
         */
        private var _id:String;
        
        /**
         * @private 
         * Holds a set of conditional transitions from this state
         */
        private var _transitions:Object;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructor
         *  @param id id for this state.
         */    
        public function State(id:String)
        {
            _id = id;
            _transitions = {};
        }

        /**
         * @return id ID for this state.
         */
        public function get id():String
        { 
            return _id;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Handling transitions
        //
        //--------------------------------------------------------------------------
            
        /**
         *  Returns <code>Transition</code>, associated with specified <code>signalID</code>.
         *
         *  @param signalID id for the <code>Signal</code> to be checked with.
         *  @return Transition object.
         *  
         *  @see Transition
         */        
        internal function transitionForSignal(signalID:String):Transition
        {
            return Transition(_transitions[signalID]);
        }
        
        /**
         *  Performs check if this <code>State</code> has transition for specified signalID.
         *
         *  @param signalID id for the signal to be checked with.
         *  @return True, if transition for given signal id exists, false otherwise.
         *  
         *  @see Transition
         */        
        internal function hasTransitionForSignal(signalID:String):Boolean
        {
            return _transitions[signalID] != null;
        }
        
        /**
         *  Creates new transition and adds it for this State.
         *
         *  @param signalID id of the <code>Signal</code> which should trigger transition.
         *  @param targetState Target <code>State</code> for the transition
         *  @return Resulting transition
         */
        internal function addTransition(signalID:String, targetState:State):Transition
        {
            var t:Transition = new Transition();
            defineTransition(t, signalID, targetState);
            return t;
        }

        /**
         *  Defines already existing <code>Transition</code> and adds it for this <code>State</code>.
         *
         *  @param transition <code>Transition</code> object to be defined.
         *  @param signalID id for the signal to trigger this transition.
         *  @param targetState New <code>State</code> this transition should lead to.
         */
        internal function defineTransition(transition:Transition, signalID:String, targetState:State):void
        {
            transition.define(this, targetState);
            _transitions[signalID] = transition;
        }
    
        /**
         *  Stringifier for the State class.
         */        
        public function toString():String
        {
            return "[object State (" + id + ")]";
        }

        //--------------------------------------------------------------------------
        //
        //  Utility methods
        //
        //--------------------------------------------------------------------------

        /**
         * Utility getter, sweeps all transitions and collects all related target states.
         * 
         * @return Vector of State objects
         */
        internal function get targets():Vector.<State>
        {
            var result:Vector.<State> = new Vector.<State>();
            var foundTargets:Dictionary = new Dictionary();
            var target:State;
            for each (var transition:Transition in _transitions)
            {
                target = transition.target;
                if (foundTargets[target] != true)
                {
                    result.push(target);
                    foundTargets[target] = true;
                }
            }
            return result;
        }

        /**
         * Utility getter, returns all transitions for this <code>State</code>.
         *
         * @return Vector of State objects
         */
        internal function get transitions():Vector.<Transition>
        {
            var result:Vector.<Transition> = new Vector.<Transition>();
            for each (var transition:Transition in _transitions)
            {
                if (result.indexOf(transition) < 0)
                    result.push(transition)
            }
            return result;
        }
    }
}
