// @license@
package nanosome.flow.stateMachine.logic
{
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
		private var _conditionalTransitions:Vector.<ConditionalTransition>;
		
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
			_conditionalTransitions = new Vector.<ConditionalTransition>();
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
		 *  @see ConditionalTransition
		 */		
		public function checkForTransition():Transition
		{
			var transition:ConditionalTransition;
			var newTransition:Transition;
			
			for each (transition in _conditionalTransitions) 
			{
				newTransition = transition.check();
				if (newTransition != null)
					return newTransition;
			}
			return null;
		}
		
		public function countEdges():uint
		{
			return _conditionalTransitions.length;
		}
		
		/**
		 *  Adds ConditionalTransition for this State.
		 *  
		 *  @param ConditionalTransition ConditionalTransition object to be added.
		 *  
		 *  @see ConditionalTransition
		 */		
		public function addTransition(transition:ConditionalTransition):void
		{
			_conditionalTransitions.push(transition);
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
