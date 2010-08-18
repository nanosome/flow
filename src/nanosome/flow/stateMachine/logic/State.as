// @license@
package nanosome.flow.stateMachine.logic
{
	/**
	 *  State object for the StateMachine class.
	 *  
	 *  @see StateMachine
	 *  
	 *  @author dimitri.fedorovs
	 */
	public class State
	{
		/**
		 * @private 
		 * Holds the id for this state.
		 */
		private var _id:String;
		
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
		}
		
		public function get id():String
		{ 
			return _id;	
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
