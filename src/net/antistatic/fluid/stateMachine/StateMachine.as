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
import flash.events.Event;

import net.antistatic.fluid.logic.BooleanCondition;

import net.antistatic.fluid.stateMachine.State;
import net.antistatic.fluid.stateMachine.logic.StateMachineLogic;
import net.antistatic.fluid.stateMachine.logic.Transition;

/**
 *  Simple implementation of FSM (Finite State Machine).
 *   
 *  It is embedding, not extending StateMachineLogic to allow single logic 
 *  to work with many state machines without excessive class spawning.
 *  
 *  The key thing to understand in StateMachine is the context.  
 *  State Machine logic is abstract, but conditions linked to it are not.
 *  BooleanCondition may accept parameters when performing checks in order to produce
 *  different results with different objects.
 *  
 *  Like:
 *  
 *  // we're creating logic and passing ContextClass required for this
 *  // logic to operate (its used in BooleanCondidions).
 *  var doubleSMLogic:StateMachineLogic = new StateMachineLogic(Sprite);
 *  // ... declaration starts here ...
 *  var ifVisible:BooleanCondition = new BooleanCondition((function(i:Sprite):Boolean { return (i.visible); }));
 *  doubleSMLogic.addCondition(ifVisible); // or something alike
 *  // ... declaration ends here ...
 *  var playPauseButton = new Button(new StateMachine(doubleSMLogic, playPauseSprite));
 *  var muteOnOffButton = new Button(new StateMachine(doubleSMLogic, muteOnOffSprite));
 *
 *	Now checks will return different results, because SM for play/pause will be checked
 *	against playPauseSprite, and mute on/off - against muteOnOffSprite.
 *	
 *	Of course you can pass null as context (and its class). In that case BooleanConditions
 *	will be checked without passing context to them and most likely will return the same results
 *	for objects with same logic, independently of their state. Usually class with logic
 *	uses itself as context.     
 *  
 *  @author ai #212983
 */
public class StateMachine extends EventDispatcher 
{
	// Messages constants for two events used in the StateMachine 
	public static const STATE_CHANGED:String = "stateChanged"; 
	public static const ACTION_CHANGED:String = "actionChanged";
	public static const HAS_CHANGED:String = "hasChanged"; 
		
	/**
	 * @private
	 * Holds a reference to current state
	 */
	protected var state:State; 
	
	/**
	 * @private
	 * Holds a reference to current action
	 */
	protected var action:String;
	
	/**
	 * @private
	 * Holds a reference to its logic
	 */
	protected var logic:StateMachineLogic;
	
	/**
	 * @private
	 * Holds a reference to StateMachine context
	 */
	protected var context:*;

	/**
	 * @private
	 * Holds a state if this SM has its own logic
	 */			 	
	protected var hasOwnLogic:Boolean;

	/**
	 * @private
	 * Holds a flag should we throw an exception if unsupported transition was tried
	 */			 	
	protected var strict:Boolean;
	
	
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
	public function StateMachine(logic:StateMachineLogic = null, context:* = null)
	{
		hasOwnLogic = (logic == null);
		this.context = hasOwnLogic ? this : context; // context is this SM itself 
		this.logic = hasOwnLogic ? new StateMachineLogic(StateMachine) : logic;
		this.strict = false;
		if(!(this.context is this.logic.getRequiredContext()))
		{
			throw new Error("This StateMachine should have '"+this.logic.getRequiredContext()+"' context!");
		}
	}
	
	/**
	 *  Perform transition
	 *  
	 *  @param transition Transition to perform
	 */			
	protected function transit(transition:Transition):void
	{
	    setState(transition.getState());
	    setAction(String(transition.getAction()));
	    dispatchEvent(new Event(HAS_CHANGED));
	}
		
	/**
	 *  Sets this State Machine as a strict one. 
	 *  Error will be thrown, if unsupported transition is used.
	 */			
	public function setAsStrict():void
	{
		strict = true;
	}

	/**
	 *  Sets new state. Override with extreme care, state is strongly binded with action parameter. 
	 *  Use transite for overriding instead.
	 *  
	 *  @param newState State to set
	 */			
	public function setState(newState:State):void
	{
		state = newState;
		dispatchEvent(new Event(STATE_CHANGED));
	}

	/**
	 *  Sets new action. Override with extreme care, action is strongly binded with state parameter.
	 *  Use transite for overriding instead.  
	 *  
	 *  @param newAction Action to set
	 */			
	protected function setAction(newAction:String):void
	{
		action = newAction;
		dispatchEvent(new Event(ACTION_CHANGED));
	}
	
	/**
	 *  Adds new state-to-state transition to its StateMachineLogic
	 *  
	 *  @param fromState State to transite from
	 *  @param condition Condition for setting new state
	 *  @param toState New state to switch to
	 */			
	public function addState(state:State):void
	{
		if(hasOwnLogic)
			logic.addState(state);
		else
			throw new Error("This StateMachine has externally set logic!");
	}	
	
	/**
	 *  Adds new state-to-state transition to its StateMachineLogic
	 *  
	 *  @param fromState State to transite from
	 *  @param condition Condition for setting new state
	 *  @param toState New state to switch to
	 */			
	public function addTransition(fromState:State, condition:BooleanCondition, toState:State, action:* = null):void
	{
		if(hasOwnLogic)
			logic.addTransition(fromState, condition, toState, action);
		else
			throw new Error("This StateMachine has externally set logic!");
	}

	/**
	 *  Performing check for State change with State instead of condition. 
	 *  Changes current action and state.
	 *  
	 *  @return True, if this state has link to the given one.
	 */		
	public function checkWithState(newState:State):Boolean
	{	
		var transition:Transition;
		var res:Boolean = false;
		
		transition = logic.checkWithState(state, newState);
	    if(transition != null)
	    {
	    	res = true;
	    	transit(transition); // process transition
	    }
	    else if(strict)
	    {
	    	throw Error("Can't change state from '"+state+"' to '"+newState+"': no such transition.");
	    }
	    
	    return res;
	}
	
	/**
	 *  Performing check for State change. 
	 *  Changes current action and state, if conditions are met.
	 *  
	 *  @return True, if conditions are met.
	 */		
	public function checkForStateChange():Boolean
	{	
		var transition:Transition;		
		var res:Boolean = false;
		
		transition = logic.checkForStateTransition(state, context);
	    if(transition != null)
	    {
	    	res = true;
	    	transit(transition); // process current transition
	    }
	    return res;
	}
	
	/**
	 *  Returns current state
	 *  
	 *  @param state Current state of the StateMachine
	 */		
	public function getCurrentState():State
	{
		return state;
	}
	
	/**
	 *  Returns current action
	 *  
	 *  @param action Current action of the StateMachine
	 */		
	public function getCurrentAction():String
	{
		return action;
	}

	public function getIDForState(state:State):uint
	{
		return logic.getIDForState(state);
	}	
}

}
