package nanosome.flow.visualizing.animators
{
    import flash.display.DisplayObject;

    import nanosome.flow.visualizing.animators.base.NumericAnimator;

    public class AlphaAnimator extends NumericAnimator
    {
        protected var _sourceValue:Number;
        protected var _targetValue:Number;

        protected var _currentValue:Number;

        protected var _deltaValue:Number;

        protected var _target:DisplayObject;

        public function init(target:DisplayObject, initialValue:Number):void
        {
            _target = target;
            _sourceValue = initialValue;
        }


    }
}
