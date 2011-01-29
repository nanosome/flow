package stateMachine.builder
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.stateMachine.processor.StateMachineProcessor;

    import org.flexunit.Assert;

    import misc.ButtonSignals;

    public class StateMachineBuilderTest
    {
        private static var _:TestStateMachineBuilder;
        private static var _stateMachine:StateMachine;

        [BeforeClass]
        public static function CreateBuildersAndStateMachines():void
        {
            var repository:TestStateMachineBuildersFactory; // you're free to do it via singleton/.getInstance
            repository = new TestStateMachineBuildersFactory();
            _ = repository.testStateMachineBuilder;
            _stateMachine = _.getStateMachine();
        }

        [Test]
        public function isImplicitInstantiationOfBuildersWorking():void
        {
            Assert.assertNotNull(_);
        }


        [Test]
        public function areAllStatesAdded():void
        {
            var states:Vector.<State> = _stateMachine.states;

            Assert.assertTrue(
                "Has 'normal' state",
                states.indexOf(_.normal) >= 0
            );

            Assert.assertTrue(
                "Has 'overed' state",
                states.indexOf(_.overed) >= 0
            );

            Assert.assertTrue(
                "Has 'pressed' state",
                states.indexOf(_.pressed) >= 0
            );

            Assert.assertTrue(
                "Has 'pressedOutside' state",
                states.indexOf(_.pressedOutside) >= 0
            );

            Assert.assertEquals(
                "Number of states",
                4, states.length
            );
        }

        [Test]
        public function areAllTransitionsAdded():void
        {
            var transitions:Vector.<Transition> = _stateMachine.transitions;

            Assert.assertTrue(
                "Has 'fromNormalToOvered' transition",
                transitions.indexOf(_.fromNormalToOvered) >= 0
            );

            Assert.assertTrue(
                "Has 'fromOveredToNormal' transition",
                transitions.indexOf(_.fromOveredToNormal) >= 0
            );

            Assert.assertTrue(
                "Has 'fromOveredToPressed' transition",
                transitions.indexOf(_.fromOveredToPressed) >= 0
            );

            Assert.assertTrue(
                "Has 'fromPressedToOvered' transition",
                transitions.indexOf(_.fromPressedToOvered) >= 0
            );
            
            Assert.assertTrue(
                "Has 'fromPressedToPressedOutside' transition",
                transitions.indexOf(_.fromPressedToPressedOutside) >= 0
            );

            Assert.assertTrue(
                "Has 'fromPressedOutsideToPressed' transition",
                transitions.indexOf(_.fromPressedOutsideToPressed) >= 0
            );

            Assert.assertTrue(
                "Has 'fromPressedOutsideToNormal' transition",
                transitions.indexOf(_.fromPressedOutsideToNormal) >= 0
            );

            Assert.assertEquals(
                "Number of transitions",
                7, transitions.length
            );
        }

        [Test]
        public function builtStateMachineLogic():void
        {
            // alternatively, we can use new ButtonSignals(), but taking signals from _smc
            // helps us to validate types before compilation
            var signals:ButtonSignals = _.getNewSignalsSet();
            var sm:StateMachine = _.getStateMachine();

            var c:StateMachineProcessor = new StateMachineProcessor(sm, signals);

            Assert.assertNotNull("Signals set obtained via StateMachineBuilder", signals);
            Assert.assertNotNull("StateMachine obtained via StateMachineBuilder", sm);

            Assert.assertEquals(
                "State of StateMachineProcessor after initialization",
                _.normal.id, c.getCurrentState().id
            );

            signals.mouseOver.fire();

            Assert.assertEquals(
                "State of StateMachineProcessor after MOUSE_OVER event",
                _.overed.id, c.getCurrentState().id
            );

            signals.mouseDown.fire();

            Assert.assertEquals(
                "State of StateMachineProcessor after MOUSE_OVER and MOUSE_DOWN events",
                _.pressed.id, c.getCurrentState().id
            );
        }
    }
}
