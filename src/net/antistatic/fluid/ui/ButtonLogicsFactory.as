////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.ui 
{

import nanosome.flow.stateMachine.logic.AbstractStateMachine;
import nanosome.flow.stateMachine.logic.State;
	
import net.antistatic.data.holder.map.PrimitiveTypeMap;
import net.antistatic.fluid.logic.BooleanCondition;

/**
 *  AbstractButton class. 
 *  Beta version, this class is about to change.
 *  
 *  @author ai #212983
 */
public class ButtonLogicsFactory
{
	public static const OVERED_LOGIC:String 			= "buttonNormalStateLogic";
	public static const PRESSED_LOGIC:String 			= "buttonOveredStateLogic";	
	public static const OVERED_PRESSED_LOGIC:String 	= "buttonOveredPressedLogic";
	
	//----------------------------------
	//  Static props
	//----------------------------------

	/**
	 * Static function returns an instance of ConsoleApp singleton. 
	 * Creating new instance, if required.
	 * 
	 * @return ConsoleApp instance
	 */
	public static function getInstance():ButtonLogicsFactory
	{
		return _instance == null ? new ButtonLogicsFactory(new SingletonLocker()) : _instance;
	}
	
	/**
	 * @private
	 * Holds the only instance of the ConsoleApp singleton.
	 */
	private static var _instance:ButtonLogicsFactory;	


	//----------------------------------
	//  Non-static props
	//----------------------------------
	
	/**
	 * @private
	 */		
	public var logics:PrimitiveTypeMap;
	
	/**
	 * @private
	 * Holds current action ID 
	 */
	private var actionID:uint;	

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 */				
	public function ButtonLogicsFactory(singletonLocker:SingletonLocker) 
	{
	    if (!singletonLocker)
            throw new Error("This class can't be created via constructor!  Use .getInstance() method instead.");
		logics = new PrimitiveTypeMap();
		_instance = this;
	}
	
	public function getLogic(key:String):AbstractStateMachine
	{
		return logics.containsKey(key) ? logics.get(key) : createLogic(key);
	}

	public function addLogic(key:String, logic:AbstractStateMachine):void
	{
		logics.put(key, logic);
	}
	
	private function createLogic(key:String):AbstractStateMachine  
	{
		var logic:AbstractStateMachine;
		var ifOvered:BooleanCondition;
		var ifPressed:BooleanCondition;
		var normalState:State;
		var overedState:State;		
		var pressedState:State;		
		var pressedOutsideState:State;		
		var conditionsFactory:ButtonConditionsFactory = ButtonConditionsFactory.getInstance();
		var statesFactory:ButtonStatesFactory = ButtonStatesFactory.getInstance();
		
		switch(key)
		{
			case OVERED_LOGIC:
				// init prerequesites
				ifOvered = conditionsFactory.getCondition(ButtonConditionsFactory.OVERED_CONDITION);
				normalState 	= statesFactory.getState(ButtonStatesFactory.NORMAL_STATE);
				overedState 	= statesFactory.getState(ButtonStatesFactory.OVERED_STATE);
				resetActionID();
				// init logic itself
				logic = new AbstractStateMachine();
				logic.addState(normalState);
				logic.addState(overedState);
				logic.addTransition(normalState, ifOvered, overedState, getActionID());
				logic.addTransition(overedState, ifOvered.no, normalState, getActionID());
				logics.put(OVERED_LOGIC, logic);
			break;
			
			case PRESSED_LOGIC:
				// init prerequesites			
				ifPressed = conditionsFactory.getCondition(ButtonConditionsFactory.PRESSED_CONDITION);
				normalState 	= statesFactory.getState(ButtonStatesFactory.NORMAL_STATE);
				pressedState 	= statesFactory.getState(ButtonStatesFactory.PRESSED_STATE);
				resetActionID();			
				// init logic itself
				logic = new AbstractStateMachine();
				logic.addState(normalState);	
				logic.addState(pressedState);
				logic.addTransition(normalState, ifPressed, pressedState, getActionID());
				logic.addTransition(pressedState, ifPressed.no, normalState, getActionID());
				logics.put(PRESSED_LOGIC, logic);
			break;
			
			case OVERED_PRESSED_LOGIC:
				// init prerequesites
				ifOvered 	= conditionsFactory.getCondition(ButtonConditionsFactory.OVERED_CONDITION);							
				ifPressed 	= conditionsFactory.getCondition(ButtonConditionsFactory.PRESSED_CONDITION);
				normalState 		= statesFactory.getState(ButtonStatesFactory.NORMAL_STATE);
				overedState 		= statesFactory.getState(ButtonStatesFactory.OVERED_STATE);
				pressedState 		= statesFactory.getState(ButtonStatesFactory.PRESSED_STATE);		
				pressedOutsideState = statesFactory.getState(ButtonStatesFactory.PRESSED_OUTSIDE_STATE);
				resetActionID();
				// init logic itself
				logic = new AbstractStateMachine();
				logic.addState(normalState);
				logic.addState(overedState);
				logic.addState(pressedState);
				logic.addState(pressedOutsideState);
				logic.addTransition(normalState, ifOvered, overedState, getActionID());
				logic.addTransition(overedState, ifOvered.no, normalState, getActionID());
				logic.addTransition(overedState, ifPressed, pressedState, getActionID());
				logic.addTransition(pressedState, ifPressed.no, overedState, getActionID());
				logic.addTransition(pressedState, ifOvered.no, pressedOutsideState, getActionID());
				logic.addTransition(pressedOutsideState, ifOvered, pressedState, getActionID());
				logic.addTransition(pressedOutsideState, ifPressed.no, normalState, getActionID());
				logics.put(OVERED_PRESSED_LOGIC, logic);
			break;	
					
			default:
				throw new Error("ButtonLogicsFactory has no '"+key+"' logic!");
			break;
		}
		return logic;		
	}

	private function resetActionID():void
	{
		actionID = 0;
	}		

	/**
	 *  Returns action ID and increments counter. 
	 *  For internal use only.
	 *  
	 *  @return action ID
	 */		 
	private function getActionID():uint
	{
		return actionID++;
	}		

}

}


//--------------------------------------------------------------------------
//
//  Singleton Locker class
//
//--------------------------------------------------------------------------
class SingletonLocker
{
	public function SingletonLocker()
	{
	}
	public function dummyMethod():void
	{
	}
}

