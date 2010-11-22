package nanosome.flow.visualizing.transforms
{
    import flash.display.Sprite;

    public class AlphaTransform implements IVisualizerTransform
    {
        private var _target:Sprite;

        public function AlphaTransform(target:Sprite)
        {
            _target = target;
        }

        public function apply(value:Number):void
        {
            _target.alpha = value;
        }
    }
}
