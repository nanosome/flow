package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.easing.EasingLineRunner;
    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.controller.VisualizerController;
    
    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;
    import misc.ButtonSignals;

    import utils.roundWithPrecision;

    public class VisualizerTest
    {
        private static var _:TestStateMachineBuilder;

        [BeforeClass]
        public static function configureStateMachineBuilder():void
        {
            var repository:TestStateMachineBuildersFactory; 
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
        }

        private var _visualizer:Visualizer;
        private var _visualizerTarget:MockSprite;

        [Before]
        public function configureVisualizerAndTarget():void
        {
            _visualizerTarget = new MockSprite();
            _visualizer = new Visualizer(new MockAlphaTransform(_visualizerTarget));

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            _visualizer.mapTransition(_.fromNormalToOvered, inEasing);
            _visualizer.mapTransition(_.fromOveredToNormal, outEasing);
            _visualizer.mapTransition(_.fromOveredToPressed, inEasing);
            _visualizer.mapValue(_.normal, .5);
            _visualizer.mapValue(_.overed, .9);
            _visualizer.mapValue(_.pressed, .3);
        }

        [After]
        public function destroyVisualizerAndTarget():void
        {
            // just in case
            _visualizer = null;
            _visualizerTarget = null;
        }


        [Test]
        public function areMissingStatesDetected():void
        {
            var totalStates:Vector.<State> = _.getStateMachine().states;
            var missingStates:Vector.<State> = _visualizer.checkMissingStates(_.getStateMachine());

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
            var missingTransitions:Vector.<Transition> = _visualizer.checkMissingTransitions(_.getStateMachine());

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
        public function isVisualizerMappingEasingsAndValues():void
        {
            _visualizer.setTransition(_.fromNormalToOvered);
            Assert.assertEquals(
                "value at starting point before setting position, value range [.5.. 9] (fromNormalToOvered)",
                .5, _visualizerTarget.alpha
            );

            _visualizer.setPosition(0);
            Assert.assertEquals(
                "value at point 0, value range [.5.. 9] (fromNormalToOvered)",
                .5, _visualizerTarget.alpha
            );

            _visualizer.setPosition(50);
            Assert.assertEquals(
                 "value at point 50 (overall duration 100), value range [.5.. .9] (fromNormalToOvered)",
                .7, _visualizerTarget.alpha
            );

            _visualizer.setPosition(110);
            Assert.assertEquals(
                "value at point 110 (overall duration 100), value range [.5.. .9] (fromNormalToOvered)",
                .9, _visualizerTarget.alpha
            );

            _visualizer.setTransition(_.fromOveredToNormal);
            
            Assert.assertEquals(
                "value at starting point before setting position, value range [.9.. .5]",
                .9, _visualizerTarget.alpha
            );

            _visualizer.setPosition(200);
            Assert.assertEquals(
                "value at ending point from overed to normal",
                .5, _visualizerTarget.alpha
            );
        }

        
        [Test]
        public function areValuesChangingOnTicking():void
        {
            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            visualizerController.setCustomTickGenerator(tickGenerator);
            visualizerController.addVisualizer(_visualizer);

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
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;

            visualizerController.setCustomTickGenerator(tickGenerator);
            visualizerController.addVisualizer(_visualizer);

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
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;

            visualizerController.setCustomTickGenerator(tickGenerator);
            visualizerController.addVisualizer(_visualizer);

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
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;

            visualizerController.setCustomTickGenerator(tickGenerator);
            visualizerController.addVisualizer(_visualizer);

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
            var secondaryVisualizer:Visualizer = new Visualizer(new MockBetaTransform(_visualizerTarget));

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            secondaryVisualizer.mapTransition(_.fromNormalToOvered, secondaryInEasing);
            secondaryVisualizer.mapTransition(_.fromOveredToNormal, secondaryOutEasing);

            secondaryVisualizer.mapValue(_.normal, 50);
            secondaryVisualizer.mapValue(_.overed, 90);

            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;

            visualizerController.setCustomTickGenerator(tickGenerator);

            visualizerController.addVisualizer(_visualizer);
            visualizerController.addVisualizer(secondaryVisualizer);

            Assert.assertEquals(
                "alpha value after initialization, precision = " + precision,
                .5, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value after initialization, precision = " + precision,
                50, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + precision,
                60, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            tickGenerator.makeTicks(100);

            Assert.assertEquals(
                "alpha value, 150 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .9, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value, 150 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + precision,
                80, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            tickGenerator.makeTicks(60);

            Assert.assertEquals(
                "beta value, 210 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + precision,
                90, roundWithPrecision(_visualizerTarget.beta, precision)
            );
            
        }

        
        [Test]
        public function severalVisualizerControllersWithOneStateMachine():void
        {
            var secondaryVisualizer:Visualizer = new Visualizer(new MockBetaTransform(_visualizerTarget));

            var secondaryInEasing:TimedEasing = new TimedEasing(Linear.easeIn, 200);
            var secondaryOutEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 400);

            secondaryVisualizer.mapTransition(_.fromNormalToOvered, secondaryInEasing);
            secondaryVisualizer.mapTransition(_.fromOveredToNormal, secondaryOutEasing);

            secondaryVisualizer.mapValue(_.normal, 50);
            secondaryVisualizer.mapValue(_.overed, 90);

            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var secondarySignals:ButtonSignals = _.getNewSignalsSet();
            var secondaryVisualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), secondarySignals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            var precision:Number = EasingLineRunner.SWITCHING_PRECISION;

            visualizerController.setCustomTickGenerator(tickGenerator);
            secondaryVisualizerController.setCustomTickGenerator(tickGenerator);

            visualizerController.addVisualizer(_visualizer);
            secondaryVisualizerController.addVisualizer(secondaryVisualizer);

            Assert.assertEquals(
                "alpha value after initialization, precision = " + precision,
                .5, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value after initialization, precision = " + precision,
                50, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            signals.mouseOver.fire();

            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 50 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .7, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), before MOUSE_OVER event, precision = " + precision,
                50, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            secondarySignals.mouseOver.fire();
            tickGenerator.makeTicks(50);

            Assert.assertEquals(
                "alpha value, 100 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .9, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value, 50 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + precision,
                60, roundWithPrecision(_visualizerTarget.beta, precision)
            );

            tickGenerator.makeTicks(160);

            Assert.assertEquals(
                "alpha value, 260 out of 100 ticks, range (.5.. .9), after MOUSE_OVER event, precision = " + precision,
                .9, roundWithPrecision(_visualizerTarget.alpha, precision)
            );

            Assert.assertEquals(
                "beta value, 210 out of 200 ticks, range (50.. 90), after MOUSE_OVER event, precision = " + precision,
                90, roundWithPrecision(_visualizerTarget.beta, precision)
            );

        }
    }
}
