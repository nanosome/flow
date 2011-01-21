package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.easing.EasingLineRunner;
    import nanosome.flow.easing.TimedEasing;
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
            var repository:TestStateMachineBuildersFactory; // you're free to do it via singleton/.getInstance
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
            _visualizer.mapValue(_.normal, .5);
            _visualizer.mapValue(_.overed, .9);
        }

        [After]
        public function destroyVisualizerAndTarget():void
        {
            // just in case
            _visualizer = null;
            _visualizerTarget = null;
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
        public function isNormalSwitchingPerformingSmoothly():void
        {

        }

        [Test]
        public function severalVisualizersWithOneController():void
        {

        }

        
        [Test]
        public function severalVisualizerControllersWithOneStateMachine():void
        {

        }
    }
}
