package visualizing
{
    import nanosome.flow.visualizing.transforms.*;
    
    import visualizing.MockSprite;

    public class MockAlphaTransform implements IVisualizerTransform
    {
        private var _targets:Array;

        public function MockAlphaTransform(target:MockSprite)
        {
            _targets = [target];
        }

        public function and(target:MockSprite):MockAlphaTransform
        {
            _targets.push(target);
            return this;
        }

        public function apply(value:Number):void
        {
            var target:MockSprite;
            for each (target in _targets)
            {
                target.alpha = value;
            }
        }
    }
}
