package nanosome.flow.easing
{
	public class EasingLine 
	{
		/**
		 *  @private
		 *  Holds function for easing.
		 */	
		private var _easing:Function;
	
		/**
		 *  @private
		 *  Holds starting value for easing
		 */	
		private var _startValue:Number;

        /**
         *  @private
         *  Holds delta value for easing
         */
        private var _deltaValue:Number;

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
		public function EasingLine(easing:Function, startValue:Number, endValue:Number)
		{
			_easing = easing;
			_startValue = startValue;
            _deltaValue = endValue - startValue;
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
		 *  Returns value of the easing function for given position and range of values.
		 *  
		 *  @param pos Position where pointer of easing is.
		 *   
		 *  @return Value of the easing function.
		 */	
		public function getValue(pos:Number, duration:Number):Number
		{
			return _easing.apply(this, [pos, _startValue, _deltaValue, duration]);
		}
		
		/**
		 *  Stringifier for instance of EasingLine class. 
		 *  
		 *  @return String
		 */	
		public function toString():String
		{
			return "[object EasingLine (" + getEasingFunction() + ", [" + _startValue + ".. " + (_startValue + _deltaValue) + ")]";
		}
		
	}

}
