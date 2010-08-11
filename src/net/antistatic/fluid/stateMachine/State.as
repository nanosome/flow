////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.stateMachine 
{

/**
 *  State object for the StateMachine class.
 *  
 *  @see StateMachine
 *  
 *  @author ai #212983
 */
public class State
{
	/**
	 * @private 
	 * Holds the value for this state, whatever it is.
	 */
	private var value:*;


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
	public function State(value:*)
	{
		this.value = value;
	}
	
	/**
	 *  Returns state's value.
	 *  
	 *  @return State value.
	 */		
	public function valueOf():*
	{
		return value;
	}

	/**
	 *  Stringifier for the State class
	 *  
	 *  @return String used for output.
	 */		
	public function toString():String
	{
		return "[object State ("+value+")]";
	}
	
}

}
