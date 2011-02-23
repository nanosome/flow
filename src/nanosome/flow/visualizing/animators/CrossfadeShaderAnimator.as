package nanosome.flow.visualizing.animators
{
    import flash.display.BitmapData;
    import flash.display.Shader;

    import flash.display.ShaderJob;
    import flash.events.Event;
    import flash.events.ShaderEvent;
    import flash.utils.ByteArray;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;

    public class CrossfadeShaderAnimator extends BaseAnimator implements IPropertyAnimator
    {
        public static const UPDATED:String = "updated";

        [Embed(source = "crossfade.pbj", mimeType = "application/octet-stream")]
        private var CrossfadeShaderClass:Class;

        protected var _target:BitmapData;

        private var _crossfadeShader:Shader;

        public function CrossfadeShaderAnimator()
        {
            super();
            _crossfadeShader = new Shader(new CrossfadeShaderClass() as ByteArray);
        }

        override public function update():void
        {
            _crossfadeShader.data.intensity.value = [this.value];
            var shaderJob:ShaderJob = new ShaderJob(_crossfadeShader, _target);
            shaderJob.addEventListener(ShaderEvent.COMPLETE, onShaderJobComplete);
            shaderJob.start();
        }

        public function setTargetAndProperty(target:*, property:String):void
        {
            if (!(target[property] is BitmapData))
                throw new Error("Target's property should be of BitmapData type");
            _target = target[property];
        }

        private function onShaderJobComplete(event:ShaderEvent):void
        {
            event.target.removeEventListener(ShaderEvent.COMPLETE, onShaderJobComplete);
            dispatchEvent(new Event(UPDATED));
        }

        override protected function compare(comparingFirstValue:*, comparingSecondValue: *):int
        {
            if (Math.abs(comparingFirstValue - comparingSecondValue) < 0.0001)
                return 0;
            return _compareNumbers(comparingFirstValue, comparingSecondValue, _endValue > _startValue);
        }

        override protected function setStartEndValues(startValue:*, endValue:*):void
        {
            _startValue = startValue.clone();
            _endValue = endValue.clone();
            _crossfadeShader.data.frontImage.input = _startValue;
            _crossfadeShader.data.backImage.input = _endValue;
        }

        override public function get value():*
        {
            return _timedEasing.easing(_position, 0, 1, _timedEasing.duration);
        }

        override public function get switchingValue():*
        {
            return _target.clone();
        }

        override protected function calculateValueToCompare(timedEasing:TimedEasing, position:Number):*
        {
            return _timedEasing.easing(position, 1, -1, timedEasing.duration);
        }
    }
}
