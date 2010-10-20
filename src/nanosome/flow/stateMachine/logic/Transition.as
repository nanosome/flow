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
	     * Holds source state.
	     */
		private var _source:State;
		
	    /**
	     * @private
	     * Holds destination state.
	     */
		private var _target:State;
		
		/**
		 * @private 
		 * Holds triggering signal for this transition
		 */
		private var _trigger:AbstractSignal;       
	       
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	       
		/**
	     *  Constructor
	     */    
		public function Transition(source:State, trigger:AbstractSignal, target:State)
	    {
	    	_source = source;
			_target = target;
			_trigger = trigger;
		}
	       
	       
		/**
	     *  Returns source state for this transition
	     */    
		public function get source():State
		{
			return _source;
		}	       
	       
		/**
	     *  Returns target state for this transition
	     */    
		public function get target():State
		{
			return _target;
		}

		/**
	     *  Returns triggering code for this transition
	     */    
		public function get trigger():AbstractSignal
		{
			return _trigger;
		}

	}

}
