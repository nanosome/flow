package nanosome.flow.easing
{
    /**
     * This class is fully specifying transition behavior for some element.
     */
	public class EasingLine extends TimedEasing
	{
        public static function createWithTimedEasing(easing:TimedEasing, startValue:Number, endValue:Number):EasingLine
        {
            return new EasingLine(easing._easing, easing._duration, startValue, endValue);
        }

		/**
		 *  @private
		 *  Holds starting value for easing
		 */	
		internal var _startValue:Number;

		/**
		 *  @private
		 *  Holds ending value for easing
		 */
		internal var _endValue:Number;
        /**
         *  @private
         *  Holds delta value for easing
         */
        internal var _deltaValue:Number;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor 
		 */
		public function EasingLine(easing:Function, duration:uint, startValue:Number, endValue:Number)
		{
            super(easing, duration);
			_startValue = startValue;
            _endValue = endValue;
            _deltaValue = _endValue - _startValue;
		}
		
		/**
		 *  Returns value of the easing function for given position and range of values.
		 *  
		 *  @param pos Position where pointer of easing is.
		 *   
		 *  @return Value of the easing function.
		 */	
		internal function getValue(pos:Number):Number
		{
			return _easing(pos, _startValue, _deltaValue, _duration);
		}

		/**
		 *  Stringifier for instance of EasingLine class. 
		 *  
		 *  @return String
		 */	
		public function toString():String
		{
			return "[object EasingLine (" +
                    "easing: " + ((_easing is Function) ? "[Function]" : "NULL OR WRONG TYPE") +
                    ", duration: " + _duration +
                    ", values: [" + _startValue + ".. " + _endValue +
                    ")]";
		}

        public function getValueForTest(pos:Number):Number
        {
            return getValue(pos);
        }
		
	}

}
