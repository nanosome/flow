// @license@
package nanosome.flow.visualizing.animators
{
    import nanosome.flow.visualizing.animators.base.*;

    public class ColorPropertyAnimator extends ColorAnimator implements IPropertyAnimator
    {
        protected var _target:*;
        protected var _property : String;

        public function ColorPropertyAnimator() {}

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
