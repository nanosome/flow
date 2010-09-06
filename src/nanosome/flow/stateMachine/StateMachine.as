// @license@
package nanosome.flow.stateMachine
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.AbstractStateMachine;
	import nanosome.flow.stateMachine.logic.Transition;
	
	/**
	 * This class is using StateMachine
	 * 
	 */
	public class StateMachine extends EventDispatcher 
	{
		// Messages constants for two events used in the StateMachine 
		public static const STATE_CHANGED:String 	= "stateChanged"; 
		public static const HAS_CHANGED:String 		= "hasChanged"; 
			
		/**
		 * @private
		 * Holds a reference to current state
		 */
		protected var _state:State;
		 
		/**
		 * @private
		 * Holds a set of currently available conditional transitions
		 */
		private var _conditionalTransitions:Vector.<ConditionalTransition>;
				
		/**
		 * @private
		 * Holds a reference to its logic
		 */
		protected var _logic:AbstractStateMachine;
		
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
		public function StateMachine(logic:AbstractStateMachine)
		{
			_logic = logic;
		}
		
		/**
		 *  Perform transition
		 *  
		 *  @param transition Transition to perform
		 */			
		protected function transit(transition:Transition):void
		{
		    _state = transition.getState();
		    dispatchEvent(new Event(HAS_CHANGED));
		}	
		
		/**
		 *  Performing check for State change. 
		 *  Changes current action and state, if conditions are met.
		 *  
		 *  @return True, if conditions are met.
		 */		
		public function checkForStateChange():Boolean
		{	
			var transition:Transition;		
			var res:Boolean = false;
			
			transition = logic.checkForStateTransition(state);
		    if(transition != null)
		    {
		    	res = true;
		    	transit(transition); // process current transition
		    }
		    return res;
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
