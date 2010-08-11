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

/**
 *  StateHub object to be used with StateMachineBehaviour class.
 *  
 *  @see StateMachineBehaviour
 *  
 *  @author ai #212983
 */
public class StateHub
{
	/**
	 * @private 
	 * Holds the state.
	 */
	private var state:State;

	/**
	 * @private 
	 * Holds an array of CondtionalTransitions to be checked with StateMachine.
	 */
	private var conditionalTransitions:Array; /* of ConditionalTransitions */

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 *  
	 *  @param state State this StateHub will be built with.
	 */	
	public function StateHub(state:State)
	{
		this.conditionalTransitions = new Array();
		this.state = state;
	}

	public function countEdges():uint
	{
		return conditionalTransitions.length;
	}

	/**
	 *  Adds ConditionalTransition for this StateHub.
	 *  
	 *  @param conditionalTransition ConditionalTransition object to be added.
	 *  
	 *  @see ConditionalTransition
	 */		
	public function addConditionalTransition(conditionalTransition:ConditionalTransition):uint
	{
		conditionalTransitions.push(conditionalTransition);
		return conditionalTransitions.length;
	}

	/**
	 *  Performs check for the new transition, returns new transition, if its conditions are met.
	 *  
	 *  @return Transition object.
	 *  
	 *  @see ConditionalTransition
	 */		
	public function checkForTransition(context:*):Transition
	{
		var transition:ConditionalTransition;
		var newTransition:Transition;
		
		for each (transition in conditionalTransitions) 
		{
			newTransition = transition.checkCondition(context);
			if(newTransition != null) break;
		}
		return newTransition;
	}

	/**
	 *  Performs check for the new transition with State object, returns new transition, if contains given State.
	 *  Please note: context is ignored.
	 *  
	 *  @return Transition object.
	 */             
	public function checkWithState(state:State):Transition
	{
		for each (var transition:ConditionalTransition in conditionalTransitions) 
		{
			if(state == transition.getState())
				return transition;
		}
		return null;
	}

	/**
	 *  Returns State for this StateHub.
	 *  
	 *  @return State.
	 */		
	public function getState():State
	{
		return state;
	}

	/**
	 *  Stringifier.
	 *  
	 *  @return String used for output.
	 */		
	public function toString():String
	{
		return "[object StateHub: state "+state+", "+conditionalTransitions+" transitions ]";
	}
	
}

}
