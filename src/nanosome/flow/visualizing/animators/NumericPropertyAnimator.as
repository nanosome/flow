package nanosome.flow.visualizing.animators
{
    import nanosome.flow.visualizing.animators.base.NumericAnimator;

    public class NumericPropertyAnimator extends NumericAnimator implements IPropertyAnimator
    {
        protected var _target:*;
        protected var _property:String;

        public function setTargetAndProperty(target:*, property:String):void
        {
            _target = target;
            _property = property;
        }

        override public function update():void
        {
            _target[_property] = this.value;
        }
    }
}
