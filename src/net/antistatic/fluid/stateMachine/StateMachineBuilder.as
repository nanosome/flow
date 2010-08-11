////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.stateMachine 
{
	
import flash.events.EventDispatcher;
import net.antistatic.fluid.stateMachine.logic.StateMachineLogic;

// transitions require Boolean conditions and IDs!

/**
 * StateMachineBuilder is using DSL Method Chaining approach to build 
 * not only state machines, but state machine logics as well. 
 *  
 * <p>Use <code>getStateMachine</code> and <code>getStateMachineLogic</code>
 * methods respectively.</p>
 *  
 * @example Usage example:
 * <listing version="3.0"> 
 * stateMachine = new StateMachineBuilder(contextClass)
 *   .state(UNKNOWN_STATE)
 * 	    .transition(ifPending,   UNKNOWN_TO_PENDING).   to(PENDING_STATE)
 *   .state(PENDING_STATE)
 * 	    .transition(ifLoading,   PENDING_TO_LOADING).   to(PENDING_TO_LOADING)
 * 	    .transition(ifTrue,      PENDING_TO_INVALID).   to(INVALID_STATE)
 * 	    .transition(ifAvailable, PENDING_TO_AVAILABLE). to(AVAILABLE_STATE)
 *   .state(LOADING_STATE)
 * 	    .transition(ifTrue,      LOADING_TO_AVAILABLE). to(AVAILABLE_STATE)
 *   .getStateMachine(UNKNOWN_STATE);
 * </listing> 
 * 
 * @see StateMachine
 * @see net.antistatic.fluid.stateMachine.logic.StateMachineLogic 
 * @see #getStateMachine()
 * @see #getStateMachineLogic()
 * @see http://martinfowler.com/dslwip/Intro.html 
 * 
 * @author ai #212983
 */
public class StateMachineBuilder extends EventDispatcher 
{
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
	public function StateMachineBuilder(logic:StateMachineLogic = null, context:* = null)
	{

	}
	
}

}
