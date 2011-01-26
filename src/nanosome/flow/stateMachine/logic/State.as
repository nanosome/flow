// @license@
package nanosome.flow.stateMachine.logic
{
	import flash.utils.Dictionary;

    import nanosome.flow.signals.Signal;

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
		private var _transitions:Dictionary;
		
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
			_transitions = new Dictionary();
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
		public function addTransition(signal:Signal, targetState:State):Transition 
		{
            var t:Transition = new Transition();
            defineTransition(t, signal, targetState);
            return t;
		}

        public function defineTransition(transition:Transition, signal:Signal, targetState:State):void
        {
            transition.define(this, targetState);
            _transitions[signal.id] = transition;
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
         * @return Array of State objects
         */
        public function getAllTargets():Array
        {
            var result:Array = [];
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
	
	}
}
