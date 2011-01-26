package visualizing
{
    import nanosome.flow.visualizing.transforms.*;
    
    import visualizing.MockSprite;

    public class MockBetaTransform implements IVisualizerTransform
    {
        private var _target:MockSprite;

        public function MockBetaTransform(target:MockSprite)
        {
            _target = target;
        }

        public function apply(value:Number):void
        {
            _target.beta = value;
        }
    }
}
