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
		 *  
		 *  @param value Value of this state.
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
		public function targetState(signalID:String):State
		{
			return Transition(_transitions[signalID]).target;
		}
		
		/**
		 *  Performs check for transition with signalID,.
		 *  
		 *  @return True, if transition exists, false otherwise.
		 *  
		 *  @see Transition
		 */		
		public function hasTransition(signalID:String):Boolean
		{
			return _transitions[signalID] != null;
		}
		
		/**
		 *  Adds Transition for this State.
		 *  
		 *  @param Transition object to be added.
		 *  
		 *  @see Transition
		 */		
		public function addTransition(signalID:String, targetState:State):void
		{
			_transitions[signalID] = new Transition(this, targetState);
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
	
	}
}
