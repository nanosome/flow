// @license@
package nanosome.flow.stateMachine
{
	
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	 * 
	 */
	public class StateMachine
	{
		/**
		 * @private
		 * Holds a set of all states
		 */
		private var _state:State;
		
				
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
		public function StateMachine(initialState:State)
		{
			_state = initialState;
		}	

	}
}
