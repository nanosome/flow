package nanosome.flow.easingLines
{
	public class EasingLine
	{
		/**
		 *  @private
		 *  Holds function for easing.
		 */
		protected var _easing:Function;
	
		/**
		 *  @private
		 *  Holds duration of the animation.
		 */
		protected var _duration:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor 
		 *  
		 *  @param easing Function used for easing.
		 *  @param duration Duration of the easing in steps.
		 */	
		public function EasingLine(easing:Function, duration:Number)
		{
			_easing = easing;
			_duration = duration;
		}
	
		/**
		 *  Returns function used for easing. 
		 *  
		 *  @return Function used for easing.
		 */	
		public function getEasingFunction():Function
		{
			return _easing;
		}
	
		/**
		 *  Returns duration of easing.
		 *  Duration is measured in steps. 
		 *  
		 *  @return Number of steps used for easing.
		 */	
		public function getDuration():Number
		{
			return _duration;
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
		protected function calculateValue(pos:Number, from:Number, delta:Number):Number
		{
			return _easing.apply(this, [pos, from, delta, _duration]);
		}
		
		/**
		 *  Stringifier for instance of EasingLine class. 
		 *  
		 *  @return String
		 */	
		public function toString():String
		{
			return "[object EasingLine (" + getEasingFunction() + ", " + getDuration() + ")]";
		}
		
	}

}
