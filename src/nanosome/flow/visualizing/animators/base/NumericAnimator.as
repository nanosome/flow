package nanosome.flow.visualizing.animators.base
{
    import nanosome.flow.visualizing.TimedEasing;
    
    public class NumericAnimator extends BaseAnimator
    {
        protected var _deltaValue:Number;

        override protected function compare(comparingFirstValue:*, comparingSecondValue: *):int
        {
            return _compareNumbers(comparingFirstValue, comparingSecondValue, _startValue, _endValue);
        }

        override protected function calculateValue(timedEasing:TimedEasing, position:Number):*
        {
            return timedEasing.easing(position, _startValue, _deltaValue, timedEasing.duration);
        }

        override protected function setStartEndValues(startValue:*, endValue:*):void
        {
            super.setStartEndValues(startValue, endValue);
            _deltaValue = _endValue - _startValue;
        }

    }
}
