package nanosome.flow.visualizing.animators.base
{
    import nanosome.flow.easing.TimedEasing;
    
    public class NumericAnimator extends BaseAnimator
    {
        public static const SWITCHING_PRECISION:Number = .001;

        protected var _deltaValue:Number;

        public function animate(easing:Function, duration:Number, fromValue:Number, toValue:Number, isReversing:Boolean):void
        {
            _animate(easing,  duration, fromValue, toValue, isReversing);
            _deltaValue = _endValue - _startValue;
        }

        // returns value less than 0, if comparingFirstValue < comparingSecondValue,
        // more than 0, if comparingFirstValue > comparingSecondValue,
        // 0, if they are equal
        override protected function compare(comparingFirstValue:*, comparingSecondValue: *, contextStartValue:*, contextEndValue:*):int
        {
            return _compareNumbers(comparingFirstValue, comparingSecondValue, contextStartValue, contextEndValue);
        }

        override protected function calculateValue(timedEasing:TimedEasing, position:Number):*
        {
            return timedEasing.easing(position, _startValue, _deltaValue, timedEasing.duration);
        }

    }
}
