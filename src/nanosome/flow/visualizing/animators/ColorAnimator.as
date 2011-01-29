package nanosome.flow.visualizing.animators
{
    import flash.display.DisplayObject;

    import nanosome.flow.visualizing.animators.abstract.BaseAnimator;

    public class ColorAnimator extends BaseAnimator
    {
        protected var _sourceValue:Number;
        protected var _targetValue:Number;

        protected var _currentValue:Number;

        protected var _deltaR:Number;
        protected var _deltaG:Number;
        protected var _deltaB:Number;

        protected var _target:DisplayObject;

        public function init(target:DisplayObject, initialValue:Number):void
        {
            _target = target;
            _sourceValue = initialValue;
        }

        public function animate(toValue:Number, easing:Function, duration:Number)
        {
            _targetValue = toValue;
            _easing = easing;
            _duration = duration;
        }

    }
}
