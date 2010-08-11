////////////////////////////////////////////////////////////////////////////////
//
//  FLUID
//  Copyright 2008-2010 | Dimitri Fedorov
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.easing
{

	/**
	 *  EasingLine class is the basic class for fluid easing. 
	 *  It holds easing function and its duration.
	 *  
	 *  @author ai #212983
	 */
	public class EasingLine 
	{
	
		/**
		 *  @private
		 *  Holds function for easing.
		 */	
		private var func:Function;
	
		/**
		 *  @private
		 *  Holds duration of the animation.
		 */	
		private var dur:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor 
		 *  
		 *  @param func Function used for easing.
		 *  @param dur Duration of the easing in steps. 
		 */	
		public function EasingLine(func:Function, dur:Number)
		{
			this.func = func;
			this.dur = dur;
		}
	
		/**
		 *  Returns function used for easing. 
		 *  
		 *  @return Function used for easing.
		 */	
		public function getFunction():Function
		{
			return func;
		}
	
		/**
		 *  Returns duration of easing.
		 *  Duration is measured in steps. 
		 *  
		 *  @return Number of steps used for easing.
		 */	
		public function getDuration():Number
		{
			return dur;
		}
		
		/**
		 *  Returns value of the easing function for given position and range of values.
		 *  
		 *  @param pos Position where pointer of easing is.
		 *  @param from Lower value for values range.
		 *  @param to Upper value for values range.
		 *   
		 *  @return Value of the easing function.
		 */	
		public function getValue(pos:Number, from:Number, to:Number):Number
		{
			return func.apply(this, [pos, from, to-from, dur]);
		}
		
		/**
		 *  Stringifier for instance of EasingLine class. 
		 *  
		 *  @return String
		 */	
		public function toString():String
		{
			return "easingLine ["+getFunction()+", "+getDuration()+"]";
		}
		
	}

}
