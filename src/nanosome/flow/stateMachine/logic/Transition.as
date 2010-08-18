// @license@
package nanosome.flow.stateMachine.logic
{
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	*  State Transition for StateMachine
	*  
	*  @see StateMachine
	*  @see State
	*  
	*  @author dimitri.fedorov
	*/
	public class Transition
	{
	    /**
	     * @private
	     * Holds destination state.
	     */
		private var _destination:State;
		
		/**
		 * @private 
		 * Holds id for this transition
		 */
		private var _id:String;       
	       
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	       
		/**
	     *  Constructor
	     */    
		public function Transition(destination:State, id:String)
	    {
			_destination = destination;
			_id = id;
		}
	       
		/**
	     *  Returns destination state for this transition
	     */    
		public function get destinationState():State
		{
			return _destination;
		}

		/**
	     *  Returns id for this transition
	     */    
		public function get id():String
		{
			return _id;
		}

	}

}
