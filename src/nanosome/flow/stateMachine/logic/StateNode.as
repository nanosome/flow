// @license@ 
package nanosome.flow.stateMachine.logic 
{
	
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	 *  StateHub object to be used with StateMachineBehaviour class.
	 *  
	 *  @see StateMachineBehaviour
	 *  
	 *  @author dimitri.fedorov
	 */
	public class StateNode
	{
		/**
		 * @private 
		 * Holds the state.
		 */
		private var _state:State;
	
		/**
		 * @private 
		 * Holds an array of CondtionalTransitions to be checked with StateMachine.
		 */
		private var _transitions:Vector.<Transition>; 
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @param state State this StateHub will be built with.
		 */	
		public function StateNode(state:State)
		{
			_transitions = new Vector.<Transition>();
			_state = state;
		}
	
		public function countEdges():uint
		{
			return _transitions.length;
		}
	
		/**
		 *  Adds Transition for this StateNode.
		 *  
		 *  @param Transition Transition object to be added.
		 *  
		 *  @see Transition
		 */		
		public function addTransition(transition:Transition):uint
		{
			_transitions.push(transition);
			return _transitions.length;
		}
	
		/**
		 *  Returns State for this StateNode.
		 *  
		 *  @return State.
		 */		
		public function get state():State
		{
			return _state;
		}
	
		/**
		 *  Stringifier.
		 *  
		 *  @return String used for output.
		 */		
		public function toString():String
		{
			return "[object StateNode: state " + _state.id + ", " + _transitions.length + " transitions ]";
		}
		
	}

}
