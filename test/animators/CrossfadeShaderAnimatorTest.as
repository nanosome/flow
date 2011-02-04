package animators
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import flash.events.Event;

    import mx.effects.easing.Linear;

    import nanosome.flow.visualizing.animators.CrossfadeShaderAnimator;

    import org.flexunit.Assert;
    import org.flexunit.async.Async;

    public class CrossfadeShaderAnimatorTest
    {
        [Embed(source = "0x880000.png")]
        public static var RedImageClass:Class;

        [Embed(source = "0x008800.png")]
        public static var GreenImageClass:Class;

        [Embed(source = "0x000088.png")]
        public static var BlueImageClass:Class;

        private static var _redImage:BitmapData;
        private static var _greenImage:BitmapData;
        private static var _blueImage:BitmapData;

        private static var _outputImage:BitmapData;

        private static var _animator:CrossfadeShaderAnimator;
        private static var _tickGenerator:TestingTickGenerator;

        private static var _processingFunc:Function;

        [BeforeClass]
        public static function prepareAssets():void
        {
            _redImage = (new RedImageClass() as Bitmap).bitmapData;
            _greenImage = (new GreenImageClass() as Bitmap).bitmapData;
            _blueImage = (new BlueImageClass() as Bitmap).bitmapData;

            _outputImage = new BitmapData(_redImage.width, _redImage.height);
            _animator = new CrossfadeShaderAnimator();
            _tickGenerator = new TestingTickGenerator();
            _animator.setCustomTickGenerator(_tickGenerator);
            _animator.setTarget(_outputImage);
        }


        [Test(async)]
        public function areStepsWorkingCorrectly():void
        {
            _animator.switchTo(Linear.easeIn, 200, _redImage, _greenImage);

            _processingFunc =  Async.asyncHandler(this, onStepOneComplete, 100, null, handleTimeout);
            _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
        }

        protected function onStepOneComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value before animation starts",
                "880000", _outputImage.getPixel(0, 0).toString(16)
           );

           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc =  Async.asyncHandler(this, onStepTwoComplete, 100, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
            
           _tickGenerator.makeTicks(100);
        }

        protected function onStepTwoComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value after animation starts, 100 steps of 200",
                "444400", _outputImage.getPixel(0, 0).toString(16)
           );

           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc =  Async.asyncHandler(this, onStepThreeComplete, 100, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.reverseTo(Linear.easeIn, 20);

           Assert.assertEquals(
                "Position after switching",
                10, _animator.position
           );

           _animator.update();
        }

        protected function onStepThreeComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value after animation starts, 100 steps of 200",
                "444400", _outputImage.getPixel(0, 0).toString(16)
           );

           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc =  Async.asyncHandler(this, onStepFourComplete, 100, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _tickGenerator.makeTicks(5);
        }

        protected function onStepFourComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value after animation starts, 100 steps of 200",
                "662200", _outputImage.getPixel(0, 0).toString(16)
           );

           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc =  Async.asyncHandler(this, onStepFiveComplete, 100, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.switchTo(Linear.easeIn, 20, _redImage, _blueImage);
           _animator.update();
        }

        protected function onStepFiveComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value after animation starts, 100 steps of 200",
                "662200", _outputImage.getPixel(0, 0).toString(16)
           );

           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc =  Async.asyncHandler(this, onStepSixComplete, 100, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _tickGenerator.makeTicks(10);
           _animator.update();
        }

        protected function onStepSixComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial pixel value after animation starts, 100 steps of 200",
                "331144", _outputImage.getPixel(0, 0).toString(16)
           );
        }
                
        protected function handleTimeout(passThroughData:Object):void
        {
            Assert.fail("Rendering takes too long");
        }

    }
}
