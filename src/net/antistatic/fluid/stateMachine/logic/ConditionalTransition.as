////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.stateMachine.logic 
{

	import net.antistatic.fluid.stateMachine.State;
	import net.antistatic.fluid.logic.BooleanCondition;
	
	/**
	 *  ConditionalTransition is holds a transition and condition to perform it.
	 *  
	 *  @see Transition
	 *  @see EasingLine
	 *  
	 *  @author ai #212983
	 */
	public class ConditionalTransition extends Transition
	{
		/**
		 * @private
		 * Holds a condition for this transition
		 */
		private var condition:BooleanCondition;
		
			
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
		public function ConditionalTransition(condition:BooleanCondition, toState:State, action:uint)
		{
			super(toState, action);
			this.condition = condition;
		}
		
		/**
		 *  Checking if this transition can be launched 
		 *  
		 *  @return Transition to perform
		 */		
		public function checkCondition():Transition
		{
			return condition.check() ? super : null;  
		}
		
	}
}
