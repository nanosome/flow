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
	*  State Transition for StateMachine
	*  
	*  @see StateMachine
	*  @see State
	*  
	*  @author ai #212983
	*/
	public class Transition
	{
	       /**
	        * @private
	        * Holds an action to perform when changing states.
	        */
	       protected var action:uint;
	
	       /**
	        * @private
	        * Holds a new state.
	        */
	       protected var state:State;
	       
	       
	       //--------------------------------------------------------------------------
	       //
	       //  Constructor
	       //
	       //--------------------------------------------------------------------------
	       
	       /**
	        *  Constructor
	        *  
	        *  @param state Target state for this transiton
	        *  @param action Action to perform when changing to state.  
	        */    
	       public function Transition(state:State, action:uint)
	       {
	               this.state = state;
	               this.action = action;
	       }
	       
	       /**
	        *  Returns state for this transition
	        *  
	        *  @param state State object
	        */    
	       public function getState():State
	       {
	               return state;
	       }
	
	       /**
	        *  Returns action for this transition
	        *  
	        *  @param action Action object
	        */    
	       public function getAction():uint
	       {
	               return action;
	       }
	}

}
