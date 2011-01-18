package nanosome.flow.easing
{
    /**
     * This class is fully specifying transition behavior for some element.
     */
	public class EasingLine extends TimedEasing
	{
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
		public function EasingLine(timedEasing:TimedEasing, startValue:Number, endValue:Number)
		{
            super(timedEasing._easing, timedEasing._duration);
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
		public function getValue(pos:Number):Number
		{
			return _easing.apply(this, [pos, _startValue, _deltaValue, _duration]);
		}

		/**
		 *  Stringifier for instance of EasingLine class. 
		 *  
		 *  @return String
		 */	
		public function toString():String
		{
			return "[object EasingLine (" +
                    " easing: " + _easing +
                    ", duration: " + _duration +
                    ", values: [" + _startValue + ".. " + _endValue +
                    ")]";
		}
		
	}

}
