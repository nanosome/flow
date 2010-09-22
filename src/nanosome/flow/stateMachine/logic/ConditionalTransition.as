// @license@

package nanosome.flow.stateMachine.logic
{
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	 *  ConditionalTransition is holds a transition and condition to perform it.
	 *  
	 *  @see Transition
	 *  
	 *  @author dimitri.fedorov
	 */
	public class ConditionalTransition extends Transition
	{
		/**
		 * @private
		 * This function should return true or false
		 */
		private var _conditionCallback:Function;
		
			
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @param condition BooleanCondition object for this condition.
		 *  @param toState New state for the transition.
		 *  @param action Action to perform when switching to the new state
		 */		
		public function ConditionalTransition(conditionCallback:Function, toState:State, id:String)
		{
			super(toState, id);
			_conditionCallback = conditionCallback;
		}
		
		/**
		 *  Checking if this transition can be launched 
		 *  
		 *  @return Transition to perform
		 */		
		public function check():Transition
		{
			return _conditionCallback() ? super : null;  
		}
		
	}
}
