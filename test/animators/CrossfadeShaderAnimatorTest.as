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
        public static const SHADER_JOB_TIMEOUT:uint = 150;

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

        private static var _processingFunc:Function;


        [BeforeClass]
        public static function prepareAssets():void
        {
            _redImage = (new RedImageClass() as Bitmap).bitmapData;
            _greenImage = (new GreenImageClass() as Bitmap).bitmapData;
            _blueImage = (new BlueImageClass() as Bitmap).bitmapData;

            _outputImage = new BitmapData(_redImage.width, _redImage.height);
            _animator = new CrossfadeShaderAnimator();

            _animator.setTargetAndProperty(new Bitmap(_outputImage), "bitmapData");
        }


        [Test(async)]
        public function areStepsWorkingCorrectly():void
        {
            _animator.switchTo(Linear.easeIn, 200, _redImage, _greenImage);

            _processingFunc = Async.asyncHandler(this, onFirstAnimatorUpdate, SHADER_JOB_TIMEOUT, null, handleTimeout);
            _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
        }

        protected function onFirstAnimatorUpdate(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Initial value of the pixel before animation starts",
                "880000", _outputImage.getPixel(0, 0).toString(16)
           );
           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc = Async.asyncHandler(this, onFirstAnimatorSteps, SHADER_JOB_TIMEOUT, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
            
           _animator.makeStep(100);
           _animator.update();
        }

        protected function onFirstAnimatorSteps(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Value of the pixel after animation starts, 100 steps of 200, linear easing, [0x88000.. 0x008800]",
                "444400", _outputImage.getPixel(0, 0).toString(16)
           );
           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc = Async.asyncHandler(this, onReversingComplete, SHADER_JOB_TIMEOUT, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.reverseTo(Linear.easeIn, 20);

           Assert.assertEquals(
                "Position after reversing from duration 200 with position 100 to duration 20, linear easing",
                10, _animator.position
           );
           _animator.update();
        }

        protected function onReversingComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Value of the pixel after update after reversing, 10 steps of 20, linear easing, [0x008800.. 0x880000]",
                "444400", _outputImage.getPixel(0, 0).toString(16)
           );
           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc = Async.asyncHandler(this, onStepsAfterReversingComplete, SHADER_JOB_TIMEOUT, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.makeStep(5);
           _animator.update();
        }

        protected function onStepsAfterReversingComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Value of the pixel after update after reversing, 15 steps of 20, linear easing, [0x008800.. 0x880000]",
                "662200", _outputImage.getPixel(0, 0).toString(16)
           );
           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc = Async.asyncHandler(this, onSwitchingComplete, SHADER_JOB_TIMEOUT, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.switchTo(Linear.easeIn, 20, _redImage, _blueImage);
           _animator.update();
        }

        protected function onSwitchingComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Value of the pixel after update after switching, 0 steps of 20, linear easing, [0x662200.. 0x000088]",
                "662200", _outputImage.getPixel(0, 0).toString(16)
           );
           _animator.removeEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc);
           _processingFunc = Async.asyncHandler(this, onStepsAfterSwitchingComplete, SHADER_JOB_TIMEOUT, null, handleTimeout);
           _animator.addEventListener(CrossfadeShaderAnimator.UPDATED, _processingFunc, false, 0, true);
           _animator.makeStep(10);
           _animator.update();
        }

        protected function onStepsAfterSwitchingComplete(event:Event, passThroughData:Object):void
        {
           Assert.assertEquals(
                "Value of the pixel after switching, 10 steps of 20, linear easing, [0x662200.. 0x000088]",
                "331144", _outputImage.getPixel(0, 0).toString(16)
           );
        }

        protected function handleTimeout(passThroughData:Object):void
        {
            Assert.fail("Shader job should take no longer than " + SHADER_JOB_TIMEOUT + " ms");
        }

    }
}
