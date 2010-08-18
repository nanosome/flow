package net.antistatic.fluid.ui 
{
	
	import net.antistatic.data.holder.map.PrimitiveTypeMap;

	import nanosome.flow.stateMachine.logic.State;

	/**
	 *  ButtonConditionsFactory class. 
	 *  
	 *  @author ai #212983
	 */
	public class ButtonStatesFactory
	{
		public static const NORMAL_STATE:String 			= "normalButtonState";
		public static const OVERED_STATE:String 			= "overedButtonState";
		public static const PRESSED_STATE:String			= "pressedButtonState";
		public static const PRESSED_OUTSIDE_STATE:String	= "pressedOutsideButtonState";
		public static const DISABLED_STATE:String			= "disabledButtonState";
		
		//----------------------------------
		//  Static props
		//----------------------------------
	
		/**
		 * Static function returns an instance of ButtonStatesFactory singleton. 
		 * Creating new instance, if required.
		 * 
		 * @return ButtonStatesFactory instance
		 */
		public static function getInstance():ButtonStatesFactory
		{
			return _instance == null ? new ButtonStatesFactory(new SingletonLocker()) : _instance;
		}
		
		/**
		 * @private
		 * Holds the only instance of the ButtonConditionsFactory singleton.
		 */
		private static var _instance:ButtonStatesFactory;	
	
	
		//----------------------------------
		//  Non-static props
		//----------------------------------
			
		/**
		 * @private
		 */		
		public var states:PrimitiveTypeMap;
		
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 */				
		public function ButtonStatesFactory(singletonLocker:SingletonLocker) 
		{
	        if (!singletonLocker)
	            throw new Error("This class can't be created via constructor! Use .getInstance() method instead.");		
			states = new PrimitiveTypeMap();
			_instance = this;		
		}
		
		public function getState(key:String):State
		{
			return states.containsKey(key) ? states.get(key) : createState(key);
		}
		
		private function createState(key:String):State  
		{
			var state:State;
			switch(key)
			{
				case NORMAL_STATE:
				case OVERED_STATE:
				case PRESSED_STATE:
				case PRESSED_OUTSIDE_STATE:
				case DISABLED_STATE:
					state = new State(key);
					states.put(key, state);
				break;
				default:
					throw new Error("ButtonStatesFactory has no '"+key+"' state!");
				break;
			}
			return state;		
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

