package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;

    import nanosome.flow.visualizing.Visualizer;
    import nanosome.flow.visualizing.VisualizerManager;


    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;
    import misc.ButtonSignals;

    import utils.roundWithPrecision;

    public class AnimationMapperTest
    {
        private static const SWITCHING_PRECISION:Number = .00001;

        private static var _:TestStateMachineBuilder;

        [BeforeClass]
        public static function configureStateMachineBuilder():void
        {
            var repository:TestStateMachineBuildersFactory; 
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
        }

        private var _alphaMapping:AnimationMapping;
        private var _visualizerTarget:InternalMockSprite;

        [Before]
        public function configureVisualizerAndTarget():void
        {
            _visualizerTarget = new InternalMockSprite();
            var animator:InternalMockAlphaAnimator = new InternalMockAlphaAnimator(); // alternatively, you can take it from the pool
            animator.setTarget(_visualizerTarget);

            _alphaMapping = new AnimationMapping();

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            _alphaMapping.mapTransition(_.fromNormalToOvered, inEasing);
            _alphaMapping.mapTransition(_.fromOveredToNormal, outEasing);
            _alphaMapping.mapTransition(_.fromOveredToPressed, inEasing);
            _alphaMapping.mapValue(_.normal, .5);
            _alphaMapping.mapValue(_.overed, .9);
            _alphaMapping.mapValue(_.pressed, .3);
        }

        [After]
        public function destroyVisualizerAndTarget():void
        {
            // just in case
            _alphaMapping = null;
            _visualizerTarget = null;
        }


        [Test]
        public function areMissingStatesDetected():void
        {
            var totalStates:Vector.<State> = _.getStateMachine().states;
            var missingStates:Vector.<State> = _alphaMapping.checkMissingStates(_.getStateMachine());

            Assert.assertEquals(
                "Number of states in state machine being visualized",
                4, totalStates.length
            );

            Assert.assertEquals(
                "Missing states (present in the state machine, but absent in visualizer)",
                1, missingStates.length
            );

            Assert.assertEquals(
                "Missing state (present in the state machine, but absent in visualizer)",
                missingStates[0], _.pressedOutside
            );
        }


        [Test]
        public function areMissingTransitionsDetected():void
        {
            var totalTransitions:Vector.<Transition> = _.getStateMachine().transitions;
            var missingTransitions:Vector.<Transition> = _alphaMapping.checkMissingTransitions(_.getStateMachine());

            Assert.assertEquals(
                "Number of transitions in state machine being visualized",
                7, totalTransitions.length
            );

            Assert.assertEquals(
                "Missing transitions (present in the state machine, but absent in visualizer)",
                4, missingTransitions.length
            );

            Assert.assertTrue(
                "Transition 'fromPressedToOvered' is missing",
                missingTransitions.indexOf(_.fromPressedToOvered) >= 0
            );

            Assert.assertTrue(
                "Transition 'fromPressedToOvered' is missing",
                missingTransitions.indexOf(_.fromPressedToOvered) >= 0
            );

            Assert.assertTrue(
                "Transition 'fromPressedToPressedOutside' is missing",
                missingTransitions.indexOf(_.fromPressedToPressedOutside) >= 0
            );

            Assert.assertTrue(
                "Transition 'fromPressedOutsideToPressed' is missing",
                missingTransitions.indexOf(_.fromPressedOutsideToPressed) >= 0
            );

            Assert.assertTrue(
                "Transition 'fromPressedOutsideToNormal' is missing",
                missingTransitions.indexOf(_.fromPressedOutsideToNormal) >= 0
            );
        }

        
        [Test]
        public function areValuesChangingOnTicking():void
        {
            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizerManager:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);  // TODO: Fix animators (use accessors?)
            alphaVisualizer.setCustomTickGenerator(tickGenerator);
            
            visualizerManager.addVisualizer(alphaVisualizer);

            Assert.assertEquals(
                "alpha value, 0 out of 100  ticks, range (.5.. .9), BEFORE event fired",
                .5, _visualizerTarget.alpha
            );

            tickGenerator.makeTicks(50);
            Assert.assertEquals(
                "alpha value, 50 out of 100  ticks, range (.5.. .9), BEFORE event fired",
                .5, _visualizerTarget.alpha
            );

            signals.mouseOver.fire();

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
            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizer:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);
            alphaVisualizer.setCustomTickGenerator(tickGenerator);
            
            visualizer.addVisualizer(alphaVisualizer);

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            signals.mouseOut.fire();

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
            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizer:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            visualizer.addVisualizer(alphaVisualizer);

            signals.mouseOver.fire();

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

            signals.mouseDown.fire();

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
            var signals:ButtonSignals = _.getNewSignalsSet();
            var vis:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            var precision:Number = SWITCHING_PRECISION;

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            vis.addVisualizer(alphaVisualizer);

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            signals.mouseDown.fire();

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
        public function severalVisualizersWithOneController():void
        {
            var animator:InternalMockBetaAnimator = new InternalMockBetaAnimator(); // alternatively, you can take it from the pool
            animator.setTarget(_visualizerTarget);
            var betaMapping:AnimationMapping = new AnimationMapping();

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            betaMapping.mapTransition(_.fromNormalToOvered, secondaryInEasing);
            betaMapping.mapTransition(_.fromOveredToNormal, secondaryOutEasing);

            betaMapping.mapValue(_.normal, 50);
            betaMapping.mapValue(_.overed, 90);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            var betaVisualizer:Visualizer = new Visualizer(betaMapping);
            betaVisualizer.setCustomTickGenerator(tickGenerator);

            var signals:ButtonSignals = _.getNewSignalsSet();
            var vis:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            vis.addVisualizer(alphaVisualizer);
            vis.addVisualizer(betaVisualizer);

            Assert.assertEquals(
                "alpha value after initialization, precision = " + SWITCHING_PRECISION,
                .5, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value after initialization, precision = " + SWITCHING_PRECISION,
                50, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .7, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                60, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            tickGenerator.makeTicks(100);

            Assert.assertEquals(
                "alpha value, 150 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .9, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 150 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                80, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            tickGenerator.makeTicks(60);

            Assert.assertEquals(
                "beta value, 210 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                90, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );
            
        }

        
        [Test]
        public function severalVisualizerControllersWithOneStateMachine():void
        {
            var animator:InternalMockBetaAnimator = new InternalMockBetaAnimator(); // alternatively, you can take it from the pool
            animator.setTarget(_visualizerTarget);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();
            var alphaVisualizer:Visualizer = new Visualizer(_alphaMapping);
            alphaVisualizer.setCustomTickGenerator(tickGenerator);

            var betaMapping:AnimationMapping = new AnimationMapping();

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            betaMapping.mapTransition(_.fromNormalToOvered, secondaryInEasing);
            betaMapping.mapTransition(_.fromOveredToNormal, secondaryOutEasing);

            betaMapping.mapValue(_.normal, 50);
            betaMapping.mapValue(_.overed, 90);

            var betaVisualizer:Visualizer = new Visualizer(betaMapping);
            betaVisualizer.setCustomTickGenerator(tickGenerator);

            var signals:ButtonSignals = _.getNewSignalsSet();
            var alphaVisualizerManager:VisualizerManager = new VisualizerManager(_.getStateMachine(), signals);

            var secondarySignals:ButtonSignals = _.getNewSignalsSet();
            var betaVisualizerManager:VisualizerManager = new VisualizerManager(_.getStateMachine(), secondarySignals);

            alphaVisualizerManager.addVisualizer(alphaVisualizer);
            betaVisualizerManager.addVisualizer(betaVisualizer);

            Assert.assertEquals(
                "alpha value after initialization, precision = " + SWITCHING_PRECISION,
                .5, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value after initialization, precision = " + SWITCHING_PRECISION,
                50, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .7, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), before MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                50, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            secondarySignals.mouseOver.fire();
            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 100 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .9, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                60, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );

            tickGenerator.makeTicks(160);

            Assert.assertEquals(
                "alpha value, 260 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                .9, roundWithPrecision(_visualizerTarget.alpha, SWITCHING_PRECISION)
            );

            Assert.assertEquals(
                "beta value, 210 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + SWITCHING_PRECISION,
                90, roundWithPrecision(_visualizerTarget.beta, SWITCHING_PRECISION)
            );
        }
    }
}

//--------------------------------------------------------------------------
//
//  Internal classes used in testing
//
//--------------------------------------------------------------------------

import nanosome.flow.visualizing.animators.base.NumericAnimator;


internal class InternalMockAlphaAnimator extends NumericAnimator
{
    protected var _target:*;

    public function setTarget(target:*):void
    {
        _target = target;
    }

    override public function update():void
    {
        _target.alpha = this.value;
    }
}


internal class InternalMockBetaAnimator extends NumericAnimator
{
    protected var _target:*;

    public function setTarget(target:*):void
    {
        _target = target;
    }

    override public function update():void
    {
        _target.beta = this.value;
    }
}


internal class InternalMockSprite
{
    public var alpha:Number;
    public var beta:Number;
}