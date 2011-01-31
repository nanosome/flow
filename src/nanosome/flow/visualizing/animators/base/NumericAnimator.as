package nanosome.flow.visualizing.animators.abstract
{
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.animators.abstract.BaseAnimator;

    public class NumericAnimator extends BaseAnimator
    {
        protected var _deltaValue:Number;

        public function animate(easing:Function, duration:Number, fromValue:Number, toValue:Number, isReversing:Boolean):void
        {
            _animate(easing,  duration, fromValue, toValue, isReversing);
            _deltaValue = _endValue - _startValue;
        }

        public function get currentValue():Number
        {
            return calculateValue(_startValue, _endValue, _timedEasing, _position);
        }

        // returns value less than 0, if comparingFirstValue < comparingSecondValue,
        // more than 0, if comparingFirstValue > comparingSecondValue,
        // 0, if they are equal
        override protected function compare(comparingFirstValue:*, comparingSecondValue: *, contextStartValue:*, contextEndValue:*):int
        {
            var biggerValue:Number;
            var lesserValue:Number;

            if (comparingFirstValue == comparingSecondValue)
                return 0;

            if (contextEndValue > contextStartValue)
            {
                lesserValue = comparingFirstValue;
                biggerValue = comparingSecondValue;
            }
            else
            {
                lesserValue = comparingSecondValue;
                biggerValue = comparingFirstValue;
            }

            if (lesserValue < biggerValue)
                return -1;

            return 1;
        }

        override protected function calculateValue(startValue:*, endValue:*, timedEasing:TimedEasing, position:Number):*
        {
            return timedEasing.easing(position, startValue, endValue - startValue, timedEasing.duration);
        }

    }
}
