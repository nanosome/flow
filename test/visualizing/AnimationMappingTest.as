package visualizing
{
    import mx.effects.easing.Linear;
    import mx.effects.easing.Quadratic;

    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;

    import org.flexunit.Assert;

    import stateMachine.builder.TestStateMachineBuilder;
    import stateMachine.builder.TestStateMachineBuildersFactory;


    public class AnimationMappingTest
    {
        private static var _:TestStateMachineBuilder;

        [BeforeClass]
        public static function configureStateMachineBuilder():void
        {
            var repository:TestStateMachineBuildersFactory; 
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
        }

        private var _testMapping:AnimationMapping;


        [Before]
        public function configureVisualizerAndTarget():void
        {
            _testMapping = new AnimationMapping();

            var inEasing:TimedEasing = new TimedEasing(Linear.easeIn, 100);
            var outEasing:TimedEasing = new TimedEasing(Quadratic.easeOut, 200);

            _testMapping.mapTransition(_.fromNormalToOvered, inEasing);
            _testMapping.mapTransition(_.fromOveredToNormal, outEasing);
            _testMapping.mapTransition(_.fromOveredToPressed, inEasing);
            _testMapping.mapValue(_.normal, .5);
            _testMapping.mapValue(_.overed, .9);
            _testMapping.mapValue(_.pressed, .3);
        }

        [After]
        public function destroyVisualizerAndTarget():void
        {
            // just in case
            _testMapping = null;
        }


        [Test]
        public function areMissingStatesDetected():void
        {
            var totalStates:Vector.<State> = _.getStateMachine().states;
            var missingStates:Vector.<State> = _testMapping.checkMissingStates(_.getStateMachine());

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
            var missingTransitions:Vector.<Transition> = _testMapping.checkMissingTransitions(_.getStateMachine());

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

    }
}