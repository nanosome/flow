package visualizing
{
    import easing.Linear;
    import easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.visualizing.AnimationMapping;

    import nanosome.flow.visualizing.TargetPropertyVisualizer;

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

            _alphaMapping.mapEasing(_.fromNormalToOvered, inEasing);
            _alphaMapping.mapEasing(_.fromOveredToNormal, outEasing);
            _alphaMapping.mapEasing(_.fromOveredToPressed, inEasing);
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
            var alphaVisualizer:TargetPropertyVisualizer = new TargetPropertyVisualizer(
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

        //----------------------------------
        //  Checking ticker logic
        //----------------------------------

        [Test]
        public function severalVisualizersWithSameTicker():void
        {
            var betaMapping:AnimationMapping = new AnimationMapping();

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            betaMapping.mapEasing(_.fromNormalToOvered, secondaryInEasing);
            betaMapping.mapEasing(_.fromOveredToNormal, secondaryOutEasing);

            betaMapping.mapValue(_.normal, 50);
            betaMapping.mapValue(_.overed, 90);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:TargetPropertyVisualizer = new TargetPropertyVisualizer(
                _alphaMapping, NumericPropertyAnimator,
                _visualizerTarget, "alpha"
            );
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            var betaVisualizer:TargetPropertyVisualizer = new TargetPropertyVisualizer(
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

import flash.events.EventDispatcher;

import nanosome.flow.visualizing.ticking.ITickGenerator;
import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

internal class TestingTickGenerator extends EventDispatcher implements ITickGenerator
{
    private var _isRunning:Boolean = false;

    public function TestingTickGenerator()
    {
    }

    public function start():void
    {
        _isRunning = true;
    }

    public function stop():void
    {
        _isRunning = false;
    }

    public function makeTicks(delta:Number):void
    {
        dispatchEvent(new TickGeneratorEvent(TickGeneratorEvent.TICK_UPDATE, delta));
    }

    public function get isRunning():Boolean
    {
        return _isRunning;
    }
}