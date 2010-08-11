////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.ui 
{
	
import net.antistatic.data.holder.map.PrimitiveTypeMap;
import net.antistatic.fluid.logic.BooleanCondition;

/**
 *  ButtonConditionsFactory class. 
 *  
 *  @author ai #212983
 */
public class ButtonConditionsFactory
{
	public static const OVERED_CONDITION:String 	= "overedButtonCondition";
	public static const PRESSED_CONDITION:String	= "pressedButtonCondition";
	
	//----------------------------------
	//  Static props
	//----------------------------------

	/**
	 * Static function returns an instance of ButtonConditionsFactory singleton. 
	 * Creating new instance, if required.
	 * 
	 * @return ButtonConditionsFactory instance
	 */
	public static function getInstance():ButtonConditionsFactory
	{
		return _instance == null ? new ButtonConditionsFactory(new SingletonLocker()) : _instance;
	}
	
	/**
	 * @private
	 * Holds the only instance of the ButtonConditionsFactory singleton.
	 */
	private static var _instance:ButtonConditionsFactory;	


	//----------------------------------
	//  Non-static props
	//----------------------------------
		
	/**
	 * @private
	 */		
	public var conditions:PrimitiveTypeMap;
	

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 */				
	public function ButtonConditionsFactory(singletonLocker:SingletonLocker) 
	{
		if (!singletonLocker)
		    throw new Error("This class can't be created via constructor!  Use .getInstance() method instead.");
		conditions = new PrimitiveTypeMap();
		_instance = this;		
	}
	
	public function getCondition(key:String):BooleanCondition
	{
		return conditions.containsKey(key) ? conditions.get(key) : addCondition(key);
	}
	
	private function addCondition(key:String):BooleanCondition  
	{
		var condition:BooleanCondition;
		switch(key)
		{
			case OVERED_CONDITION:
				condition = new BooleanCondition((function(button:AbstractButton):Boolean { return button.isOvered(); }));
				conditions.put(OVERED_CONDITION, condition);
			break;
			case PRESSED_CONDITION:
				condition = new BooleanCondition((function(button:AbstractButton):Boolean { return button.isPressed(); }));
				conditions.put(PRESSED_CONDITION, condition);
			break;
			
			default:
				throw new Error("ButtonConditionsFactory has no '"+key+"' condition!");
			break;
		}
		return condition;		
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

