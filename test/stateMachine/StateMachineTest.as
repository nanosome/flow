package stateMachine
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.processor.StateMachineProcessor;

    import nanosome.flow.stateMachine.processor.StateMachineProcessorEvent;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    import org.flexunit.Assert;

    import misc.ButtonSignals;

    public class StateMachineTest
    {
        private static var _normalState:State;
        private static var _overedState:State;
        private static var _overedAndPressedState:State;
        private static var _pressedOutsideState:State;

        private static var _normalToOveredTransition:Transition;
        private static var _overedToNormalTransition:Transition;
        private static var _overedToPressedTransition:Transition;
        private static var _pressedToOveredTransition:Transition;
        private static var _pressedToPressedOutsideTransition:Transition;
        private static var _pressedOutsideToPressedTransition:Transition;
        private static var _pressedOutsideToNormalTransition:Transition;

        private static var _stateMachine:StateMachine;

        [BeforeClass]
        public static function configureStateMachine():void
        {
            var s:ButtonSignals = new ButtonSignals();

            _normalState = new State("normal");
            _overedState = new State("overed");
            _overedAndPressedState = new State("overedAndPressed");
            _pressedOutsideState = new State("pressedOutside");

            _stateMachine = new StateMachine(_normalState);

            _normalToOveredTransition =
                    _normalState.addTransition(s.mouseOver, _overedState);

            _overedToNormalTransition =
                    _overedState.addTransition(s.mouseOut, _normalState);

            _overedToPressedTransition =
                    _overedState.addTransition(s.mouseDown, _overedAndPressedState);

            _pressedToOveredTransition =
                    _overedAndPressedState.addTransition(s.mouseUp, _overedState);

            _pressedToPressedOutsideTransition =
                _overedAndPressedState.addTransition(s.mouseOut, _pressedOutsideState);

            _pressedOutsideToPressedTransition =
                _pressedOutsideState.addTransition(s.mouseOver, _overedAndPressedState);

            _pressedOutsideToNormalTransition =
                _pressedOutsideState.addTransition(s.mouseUp, _normalState);
        }

        [Test]
        public function consequentStateTriggering():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var controller:StateMachineProcessor = new StateMachineProcessor(_stateMachine, s);
            s.mouseOver.fire();
            s.mouseDown.fire();
            s.mouseOver.fire();

            Assert.assertEquals(
                "State after MOUSE_OVER and MOUSE_DOWN events",
                _overedAndPressedState, controller.getCurrentState()
            );
        }

        private var _event:StateMachineProcessorEvent;

        [Test]
        public function consequentTransitionEvents():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var processor:StateMachineProcessor = new StateMachineProcessor(_stateMachine, s);

            processor.addEventListener(StateMachineProcessorEvent.STATE_CHANGED, onSMControllerEvent);
            s.mouseOver.fire();

            Assert.assertEquals(
                "Transition in StateMachineProcessor event after MOUSE_OVER event",
                _normalToOveredTransition, _event.transition
            );

            Assert.assertEquals(
                "Old state in StateMachineProcessor event after MOUSE_OVER event",
                _normalState, _event.oldState
            );

            s.mouseDown.fire();

            Assert.assertEquals(
                "Transition in StateMachineProcessor event after MOUSE_OVER and MOUSE_DOWN events",
                _overedToPressedTransition, _event.transition
            );

            Assert.assertEquals(
                "Old state in StateMachineProcessor event after MOUSE_OVER and MOUSE_DOWN events",
                _overedState, _event.oldState
            );
        }

        private function onSMControllerEvent(event:StateMachineProcessorEvent):void
        {
            _event = event;
        }

        [Test]
        public function twoControllersWithSameLogicAndSignalLayers():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var processorOne:StateMachineProcessor = new StateMachineProcessor(_stateMachine, s);
            var processorTwo:StateMachineProcessor = new StateMachineProcessor(_stateMachine, s);

            s.mouseOver.fire();

            Assert.assertEquals(
                "State of the first StateMachineProcessor after MOUSE_OVER event",
                _overedState, processorOne.getCurrentState()
            );

            Assert.assertEquals(
                "State of the second StateMachineProcessor after MOUSE_OVER event",
                _overedState, processorTwo.getCurrentState()
            );
        }

        [Test]
        public function twoControllersWithSameLogicButDifferentSignalLayers():void
        {
            var sOne:ButtonSignals = new ButtonSignals();
            var sTwo:ButtonSignals = new ButtonSignals();
            var controllerOne:StateMachineProcessor = new StateMachineProcessor(_stateMachine, sOne);
            var controllerTwo:StateMachineProcessor = new StateMachineProcessor(_stateMachine, sTwo);

            sOne.mouseOver.fire();
            sTwo.mouseOver.fire();
            sTwo.mouseDown.fire();

            Assert.assertEquals(
                "State of the first controller after MOUSE_OVER event",
                _overedState, controllerOne.getCurrentState()
            );

            Assert.assertEquals(
                "State of the second after MOUSE_OVER event",
                _overedAndPressedState, controllerTwo.getCurrentState()
            );
        }

    }
}
