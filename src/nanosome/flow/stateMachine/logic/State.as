// @license@
package nanosome.flow.stateMachine.logic
{
    import flash.utils.Dictionary;

    /**
     *  State object for the StateMachine class.
     *  
     *  @see StateMachine
     *  
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
         */    
        public function State(id:String)
        {
            _id = id;
            _transitions = {};
        }
        
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
         *  Performs check for the new transition, returns new transition, if its conditions are met.
         *  
         *  @return Transition object.
         *  
         *  @see Transition
         */        
        public function transitionForEvent(signalID:String):Transition
        {
            return Transition(_transitions[signalID]);
        }
        
        /**
         *  Performs check for transition with signalID,.
         *  
         *  @return True, if transition exists, false otherwise.
         *  
         *  @see Transition
         */        
        public function hasTransitionForEvent(signalID:String):Boolean
        {
            return _transitions[signalID] != null;
        }
        
        /**
         *  Adds Transition for this State.
         */
        public function addTransition(signalID:String, targetState:State):Transition
        {
            var t:Transition = new Transition();
            defineTransition(t, signalID, targetState);
            return t;
        }
        //TODO: Code smell
        public function defineTransition(transition:Transition, signalID:String, targetState:State):void
        {
            transition.define(this, targetState);
            _transitions[signalID] = transition;
        }
    
        /**
         *  Stringifier for the State class
         *  
         *  @return String used for output.
         */        
        public function toString():String
        {
            return "[object State (" + id + ")]";
        }

        /**
         * Utility method, sweeps all transitions and collects all related targets.
         * 
         * @return Vector of State objects
         */
        // TODO: Cache getAllTargets
        public function get targets():Vector.<State>
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
         * Utility method, returns all transitions of this state.
         *
         * @return Vector of State objects
         */
        // TODO: Cache getAllTransitions
        public function get transitions():Vector.<Transition>
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
