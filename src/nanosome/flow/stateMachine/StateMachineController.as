// @license@
package nanosome.flow.stateMachine
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	 * 
	 */
	public class StateMachineController extends EventDispatcher 
	{
		// Messages constants for events
		public static const STATE_CHANGED:String 	= "stateChanged"; 
			
		/**
		 * @private
		 * Holds a reference to current state
		 */
		protected var _currentState:State;
		 
		/**
		 * @private
		 * Holds a reference to state machine currently working with
		 */
		private var _stateMachine:StateMachine;
		
				
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
		public function StateMachineController(stateMachine:StateMachine)
		{
			_stateMachine = stateMachine;
		}
		
		
		/**
		 *  Performing check for State change. 
		 *  Changes current action and state, if conditions are met.
		 *  
		 *  @return True, if conditions are met.
		 */		
		public function handle(eventCode:String):Boolean
		{	
		    if(_currentState.hasTransition(eventCode))
		    {
		    	transitionTo(_currentState.targetState(eventCode));
		    	return true;
		    }
		    return false;
		}
		
		/**
	 	 *  Sets new state. 
	 	 *  
	 	 *  @param newState State to set
	 	 */			
		public function transitionTo(target:State):void
		{
			_currentState = target;
			dispatchEvent(new Event(STATE_CHANGED));
		}
	
	}
}
