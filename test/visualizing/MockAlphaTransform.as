package visualizing
{
    import nanosome.flow.visualizing.transforms.*;
    
    import visualizing.MockSprite;

    public class MockAlphaTransform implements IVisualizerTransform
    {
        private var _target:MockSprite;

        public function MockAlphaTransform(target:MockSprite)
        {
            _target = target;
        }

        public function apply(value:Number):void
        {
            _target.alpha = value;
        }
    }
}
