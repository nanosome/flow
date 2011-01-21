package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.controller.VisualizerController;

    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;
    import misc.ButtonSignals;

    public class VisualizerTest
    {
        private var _:TestStateMachineBuilder;

        [Before]
        public function configureStateMachineBuilder():void
        {
            var repository:TestStateMachineBuildersFactory; // you're free to do it via singleton/.getInstance
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
        }

        [Test]
        public function isVisualizerMappingAndEasingsAndValues():void
        {
            var visualizerTarget:MockSprite = new MockSprite();
            var visualizer:Visualizer = new Visualizer(new MockAlphaTransform(visualizerTarget));

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            visualizer.mapTransition(_.fromNormalToOvered, inEasing);
            visualizer.mapTransition(_.fromOveredToNormal, outEasing);
            visualizer.mapValue(_.normal, .5);
            visualizer.mapValue(_.overed, .9);

            visualizer.setTransition(_.fromNormalToOvered);
            Assert.assertEquals(
                "value at starting point before setting position, value range [.5.. 9] (fromNormalToOvered)",
                .5, visualizerTarget.alpha
            );

            visualizer.setPosition(0);
            Assert.assertEquals(
                "value at point 0, value range [.5.. 9] (fromNormalToOvered)",
                .5, visualizerTarget.alpha
            );

            visualizer.setPosition(50);
            Assert.assertEquals(
                 "value at point 50 (overall duration 100), value range [.5.. .9] (fromNormalToOvered)",
                .7, visualizerTarget.alpha
            );

            visualizer.setPosition(100);
            Assert.assertEquals(
                "value at point 100 (overall duration 100), value range [.5.. .9] (fromNormalToOvered)",
                .9, visualizerTarget.alpha
            );

            visualizer.setTransition(_.fromOveredToNormal);
            
            Assert.assertEquals(
                "value at starting point before setting position, value range [.9.. .5]",
                .9, visualizerTarget.alpha
            );

            // at its ending point, value should be equal to mapped value for _normal state
            visualizer.setPosition(200);
            Assert.assertEquals("value at ending point from overed to normal", .5, visualizerTarget.alpha);
        }

        [Test]
        public function isVisualizerControllerWorking():void
        {
            // Testing visualizing parameter changes without controlling visualizer directly,
            // but via StateMachineController

            var visualizerTarget:MockSprite = new MockSprite();
            var visualizer:Visualizer = new Visualizer(new MockAlphaTransform(visualizerTarget));

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Linear.easeOut, 200);

            visualizer.mapTransition(_.fromNormalToOvered, inEasing);
            visualizer.mapTransition(_.fromOveredToNormal, outEasing);
            visualizer.mapValue(_.normal, .5);
            visualizer.mapValue(_.overed, .9);

            var signals:ButtonSignals = _.getNewSignalsSet();
            var visualizerController:VisualizerController = new VisualizerController(_.getStateMachine(), signals);

            var tickGenerator:TestingTickGenerator = new TestingTickGenerator();

            visualizerController.setCustomTickGenerator(tickGenerator);
            visualizerController.addVisualizer(visualizer);

            Assert.assertEquals(.5, visualizerTarget.alpha);

            // alpha should be still .5, because state has not changed
            tickGenerator.makeTicks(50);
            Assert.assertEquals(.5, visualizerTarget.alpha);

            signals.mouseOver.fire();
            tickGenerator.makeTicks(50);
            Assert.assertEquals(.7, visualizerTarget.alpha);

            tickGenerator.makeTicks(50);
            Assert.assertEquals(.9, visualizerTarget.alpha);

            tickGenerator.makeTicks(10);
            Assert.assertEquals(.9, visualizerTarget.alpha);

        }
    }
}
