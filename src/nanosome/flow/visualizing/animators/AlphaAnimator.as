package nanosome.flow.visualizing.animators
{
    import flash.display.DisplayObject;
    import nanosome.flow.visualizing.animators.base.NumericAnimator;

    public class AlphaAnimator extends NumericAnimator
    {
        protected var _target:DisplayObject;

        public function setTarget(target:DisplayObject):void
        {
            _target = target;
        }

        override public function update():void
        {
            _target.alpha = this.value;
        }
    }
}
