package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.AnimationMapping;

    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.animators.NumericPropertyAnimator;

    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;

    import utils.roundWithPrecision;

    public class VisualizerTest
    {
        private static const SWITCHING_PRECISION:Number = .00001;

        private static var _:TestStateMachineBuilder;
        private static var _alphaMapping:AnimationMapping;

        [BeforeClass]
        public static function configureStateMachineBuilder():void
        {
            var repository:TestStateMachineBuildersFactory; 
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            _alphaMapping = new AnimationMapping();

            _alphaMapping.mapTransition(_.fromNormalToOvered, inEasing);
            _alphaMapping.mapTransition(_.fromOveredToNormal, outEasing);
            _alphaMapping.mapTransition(_.fromOveredToPressed, inEasing);
            _alphaMapping.mapValue(_.normal, .5);
            _alphaMapping.mapValue(_.overed, .9);
            _alphaMapping.mapValue(_.pressed, .3);
        }


        private var _visualizerTarget:InternalMockSprite;

        [Before]
        public function configureVisualizer():void
        {
            _visualizerTarget = new InternalMockSprite();
        }

        [After]
        public function destroyVisualizer():void
        {
            _visualizerTarget = null; // just in case
        }


        [Test]
        public function areValuesChangingOnTicking():void
        {
            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(
                    _alphaMapping, NumericPropertyAnimator,
                    _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            alphaVisualizer.setInitialState(_.normal);

            Assert.assertEquals(
                "alpha value, 0 out of 100  ticks, range (.5.. .9), BEFORE event fired",
                .5, _visualizerTarget.alpha
            );

            tickGenerator.makeTicks(50);
            Assert.assertEquals(
                "alpha value, 50 out of 100  ticks, range (.5.. .9), BEFORE event fired",
                .5, _visualizerTarget.alpha
            );

            alphaVisualizer.setTransition(_.fromNormalToOvered);

            tickGenerator.makeTicks(50);
            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), AFTER event fired",
                .7, _visualizerTarget.alpha
            );

            tickGenerator.makeTicks(50);
            Assert.assertEquals(
                "alpha value, 100 out of 100 ticks, range (.5.. .9), AFTER event fired",
                .9, _visualizerTarget.alpha
              );

            tickGenerator.makeTicks(10);
            Assert.assertEquals(
                "alpha value, 110 out of 100 ticks, range (.5.. .9), AFTER event fired",
                .9, _visualizerTarget.alpha
            );
        }


        [Test]
        public function isReversingSwitchingPerformingSmoothly():void
        {
            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(
                _alphaMapping, NumericPropertyAnimator,
                _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            alphaVisualizer.setInitialState(_.normal);
            alphaVisualizer.setTransition(_.fromNormalToOvered);

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            alphaVisualizer.setTransition(_.fromOveredToNormal);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OUT event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            tickGenerator.makeTicks(150);
            Assert.assertEquals(
                "alpha value",
                .5, _visualizerTarget.alpha
              );
        }


        [Test]
        public function isNormalFullSwitchingPerformingSmoothly():void
        {
            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(
                _alphaMapping, NumericPropertyAnimator,
                _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            alphaVisualizer.setInitialState(_.normal);
            alphaVisualizer.setTransition(_.fromNormalToOvered);

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            tickGenerator.makeTicks(60);

            Assert.assertEquals(
                "alpha value, 110 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .9, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            alphaVisualizer.setTransition(_.fromOveredToPressed);

            Assert.assertEquals(
                "alpha value, 0 out of 100 ticks, range (.9.. .3), after MOUSE_DOWN event, precision = " + precision,
                .9, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.9.. .3), after MOUSE_DOWN event, precision = " + precision,
                .6, roundWithPrecision(_visualizerTarget.alpha, precision)
              );

            tickGenerator.makeTicks(60);

            Assert.assertEquals(
                "alpha value, 110 out of 100 ticks, range (.9.. .3), after MOUSE_DOWN event, precision = " + precision,
                .3, roundWithPrecision(_visualizerTarget.alpha, precision)
              );
        }


        [Test]
        public function isNormalPartialSwitchingPerformingSmoothly():void
        {
            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(
                _alphaMapping, NumericPropertyAnimator,
                _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            alphaVisualizer.setInitialState(_.normal);
            alphaVisualizer.setTransition(_.fromNormalToOvered);

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            alphaVisualizer.setTransition(_.fromOveredToPressed);

            Assert.assertEquals(
                "alpha value, 0 out of 100 ticks, range (.7.. .3), after MOUSE_DOWN event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.7.. .3), after MOUSE_DOWN event, precision = " + precision,
                .5, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            tickGenerator.makeTicks(60);

            Assert.assertEquals(
                "alpha value, 110 out of 100 ticks, range (.9.. .3), after MOUSE_DOWN event, precision = " + precision,
                .3, roundWithPrecision(_visualizerTarget.alpha, precision)
            );
        }


        [Test]
        public function severalVisualizersWithSameTicker():void
        {
            var betaMapping:AnimationMapping = new AnimationMapping();

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            betaMapping.mapTransition(_.fromNormalToOvered, secondaryInEasing);
            betaMapping.mapTransition(_.fromOveredToNormal, secondaryOutEasing);

            betaMapping.mapValue(_.normal, 50);
            betaMapping.mapValue(_.overed, 90);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(
                _alphaMapping, NumericPropertyAnimator,
                _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            var betaVisualizer:Visualizer = new Visualizer(
                betaMapping, NumericPropertyAnimator,
                _visualizerTarget, "beta"
            );
            betaVisualizer.setCustomTickGenerator(tickGenerator);

            alphaVisualizer.setInitialState(_.normal);
            betaVisualizer.setInitialState(_.normal);

            Assert.assertEquals(
                "alpha value after initialization, precision = " + SWITCHING_PRECISION,
                .5, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value after initialization, precision = " + SWITCHING_PRECISION,
                50, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            alphaVisualizer.setTransition(_.fromNormalToOvered);
            betaVisualizer.setTransition(_.fromNormalToOvered);

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .7, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                60, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );
        }
    }
}

//--------------------------------------------------------------------------
//
//  Internal classes used in testing
//
//--------------------------------------------------------------------------

internal class InternalMockSprite
{
    public var alpha:Number;
    public var beta:Number;
}