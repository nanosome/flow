package nanosome.flow.visualizing.animators.abstract
{
    import nanosome.flow.visualizing.animators.abstract.BaseAnimator;

    public class NumericAnimator extends BaseAnimator
    {
        protected var _sourceValue:Number;
        protected var _targetValue:Number;

        protected var _deltaValue:Number;

        public function animate(toValue:Number, easing:Function, duration:Number)
        {
            _targetValue = toValue;
            _sourceValue = currentValue;
            _deltaValue = _targetValue - _sourceValue;

            _easing = easing;
            _duration = duration;
            _percentage = 0;
        }

        protected function get currentValue():Number
        {
            return _sourceValue + _deltaValue * _percentage;
        }
    }
}
