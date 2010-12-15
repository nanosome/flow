package tests.visualizer
{
    import flash.display.Sprite;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.stateMachine.StateMachine;

    import nanosome.flow.easingLines.EasingLine;
    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.controller.VisualizerController;
    import nanosome.flow.visualizing.transforms.AlphaTransform;

    import org.flexunit.Assert;

    import tests.builder.TestStateMachineBuilder;
    import tests.builder.TestStateMachineBuildersFactory;
    import tests.misc.ButtonSignals;

    public class VisualizerTest
    {
        private var _:TestStateMachineBuilder;

        [Before]
        public function configureStateMachine():void
        {
            var repository:TestStateMachineBuildersFactory; // you're free to do it via singleton/.getInstance
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
        }

        [Test]
        public function mappingVisualizer():void
        {
            var visualizerTarget:Sprite;
            var visualizer:Visualizer = new Visualizer(new AlphaTransform(visualizerTarget));

            var inEasingLine:EasingLine = new EasingLine(Quadratic.easeIn, 100);
            var outEasingLine:EasingLine = new EasingLine(Quadratic.easeOut, 200);

            visualizer.mapTransition(_.fromNormalToOvered, inEasingLine);
            visualizer.mapTransition(_.fromOveredToNormal, outEasingLine);
            visualizer.mapValue(_.normal, .5);
            visualizer.mapValue(_.overed, .9);

        }

        [Test]
        public function inProgress():void
        {
            var visualizerTarget:Sprite;
            var visualizer:Visualizer = new Visualizer(new AlphaTransform(visualizerTarget));

            var inEasingLine:EasingLine = new EasingLine(Quadratic.easeIn, 100);
            var outEasingLine:EasingLine = new EasingLine(Quadratic.easeOut, 200);

            visualizer.mapTransition(_.fromNormalToOvered, inEasingLine);
            visualizer.mapTransition(_.fromOveredToNormal, outEasingLine);
            visualizer.mapValue(_.normal, .5);
            visualizer.mapValue(_.overed, .9);
            // TODO: Add throwing an exception if not all fields are filled

            var signals:ButtonSignals = _.getNewSignalsSet();
            var sm:StateMachine = _.getStateMachine();

            var c:VisualizerController = new VisualizerController(sm, signals);
            c.addVisualizer(visualizer);

            Assert.assertNotNull(signals);
            Assert.assertNotNull(sm);
            Assert.assertNotNull(c);

            Assert.assertEquals(_.normal.id, c.getCurrentState().id);
            signals.mouseOver.fire();
            Assert.assertEquals(_.overed.id, c.getCurrentState().id);
            signals.mouseDown.fire();
            Assert.assertEquals(_.pressed.id, c.getCurrentState().id);
        }
    }
}
