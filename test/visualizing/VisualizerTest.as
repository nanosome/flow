package visualizing
{
    import flash.display.Sprite;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.stateMachine.StateMachine;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.visualizing.Visualizer;

    import nanosome.flow.visualizing.controller.VisualizerController;
    import nanosome.flow.visualizing.transforms.AlphaTransform;

    import org.flexunit.Assert;

    import builder.TestStateMachineBuilder;
    import builder.TestStateMachineBuildersFactory;
    import misc.ButtonSignals;

    import org.flexunit.flexui.patterns.AssertEqualsPattern;

    import visualizing.MockSprite;

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
        public function isVisualizerMappingEasingsAndValues():void
        {
            var visualizerTarget:MockSprite = new MockSprite();
            var visualizer:Visualizer = new Visualizer(new MockAlphaTransform(visualizerTarget));

            var inEasing:TimedEasing = new TimedEasing(Quadratic.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            // '_' should be an already built state machine, with states and transitions
            visualizer.mapTransition(_.fromNormalToOvered, inEasing);
            visualizer.mapTransition(_.fromOveredToNormal, outEasing);
            visualizer.mapValue(_.normal, .5);
            visualizer.mapValue(_.overed, .9);

            // trying fromNormalToOvered transition
            visualizer.setTransition(_.fromNormalToOvered);

            // at its starting point, value should be equal to mapped value for _normal state
            visualizer.setPosition(0);
            Assert.assertEquals(.5, visualizerTarget.alpha);

            // at its ending point, value should be equal to mapped value for _overed state
            visualizer.setPosition(100);
            Assert.assertEquals(.9, visualizerTarget.alpha);

            // now let's check fromOveredToNormal transition
            visualizer.setTransition(_.fromOveredToNormal);
            
            // at its starting point, value should be equal to mapped value for _overed state
            visualizer.setPosition(0);
            Assert.assertEquals(.9, visualizerTarget.alpha);

            // at its ending point, value should be equal to mapped value for _normal state
            visualizer.setPosition(200);
            Assert.assertEquals(.5, visualizerTarget.alpha);
        }

        [Test]
        public function inProgress():void
        {

        }
    }
}
