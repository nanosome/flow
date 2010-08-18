// @license@
package nanosome.flow.stateMachine.logic 
{
	import nanosome.flow.stateMachine.logic.State;
	
	/**
	 * StateMachineLogic defines a classic FSM (http://en.wikipedia.org/wiki/Finite-state_machine), 
	 * without saving its actual state. Keeping state away from definition is useful for having 
	 * many objects with same logic, but different actual states, like buttons.
	 *  
	 * Core objects are: State, Transition, TransitionCondition.
	 *   
	 *  @see StateMachine
	 *  
	 *  @author dimitri.fedorov
	 */
	public class AbstractStateMachine
	{
	
		/**
		 * @private 
		 * Holds a vector for state nodes.
		 */
		private var _stateNodes:Vector.<StateNode>;
		
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
		public function AbstractStateMachine()
		{
			_stateNodes = new Vector.<StateNode>();
		}

		public function countStates():uint
		{
			return _stateNodes.length;
		}
	
		public function countEdges():uint
		{
			var stateHub:StateNode;
			var count:uint = 0;
			for each (stateHub in _stateNodes)
				count += stateHub.countEdges();
			return count;
		}
		
		/**
		 *  Adds new State to the behaviour and returns number of states.
		 *  
		 *  @param state State to be added.
		 *  
		 *  @return number of the states in this behaviour
		 */	
		public function addState(state:State):uint
		{
			if(hasStateNode(state))
				throw new Error("This behaviour already has State " + state);
			else 
				_stateNodes.push(new StateNode(state));
			return _stateNodes.length;
		}
		
		/**
		 *  Adds multiple States to the behaviour and returns new number of states.
		 *  Use with caution.
		 *  
		 *  @param list of States to be added.
		 *  
		 *  @return number of the states in this behaviour
		 */	
		public function addStates(...states):uint
		{
			for each(var state:State in states)
				addState(state);
	
			return _stateNodes.length;
		}	
	
		/**
		 *  Adds ConditionalTransition for the State.
		 *  
		 *  @param fromState State we're adding transition for.
		 *  @param conditionalTransition ConditionalTransition object to be added.
		 *  
		 *  @see ConditionalTransition
		 */		
		public function addTransition(fromState:State, transition:Transition):void
		{
			if(hasStateNode(fromState) && hasStateNode(transition.destinationState))
			{
				getStateNode(fromState).addTransition(transition);
			}
			else 
				throw new Error("StateMachineLogic should contain States '" + fromState.id + "' and '" + transition.destinationState.id + "' both to add transition!");
		}
	
		/**
		 *  Stringifier for the State class
		 *  
		 *  @return String used for output.
		 */		
		public function toString():String
		{
			return "[object AbstractStateMachine: " + _stateNodes.length + " state nodes ]";
		}
	
		public function hasStateNode(state:State):Boolean
		{
			return getStateNode(state) != null;
		}
		
		public function getStateNode(state:State):StateNode
		{
			var stateNode:StateNode;
			for each(stateNode in _stateNodes)
				if (stateNode.state == state) return stateNode;
			return null;
		}
	}
}

