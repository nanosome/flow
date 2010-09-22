// @license@
package nanosome.flow.stateMachine
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.Transition;
	
	/**
	 * 
	 */
	public class StateMachine extends EventDispatcher 
	{
		// Messages constants for events used in the StateMachine 
		public static const STATE_CHANGED:String 	= "stateChanged"; 
			
		/**
		 * @private
		 * Holds a reference to current state
		 */
		protected var _state:State;
		 
		/**
		 * @private
		 * Holds a set of currently available conditional transitions
		 */
		private var _states:Vector.<State>;
		
				
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @param initialState Initial state to start with
		 */			
		public function StateMachine()
		{
			_states = new Vector.<State>();
		}
		
		
		/**
		 *  Performing check for State change. 
		 *  Changes current action and state, if conditions are met.
		 *  
		 *  @return True, if conditions are met.
		 */		
		public function checkForStateChange():Boolean
		{	
			var transition:Transition = _state.checkForTransition();
			
		    if(transition != null)
		    {
		    	setState(transition.destinationState);
		    	return true;
		    }
		    return false;
		}
		
		/**
	 	 *  Sets new state. Override with extreme care, state is strongly binded with action parameter. 
	 	 *  Use transite for overriding instead.
	 	 *  
	 	 *  @param newState State to set
	 	 */			
		public function setState(newState:State):void
		{
			_state = newState;
			dispatchEvent(new Event(STATE_CHANGED));
		}
	
		/**
		 *  Returns current state
		 *  
		 *  @param state Current state of the StateMachine
		 */		
		public function get currentState():State
		{
			return _state;
		}
	}
}
