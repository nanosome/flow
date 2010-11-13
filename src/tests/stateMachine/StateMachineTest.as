package tests.stateMachine
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.controller.StateMachineController;

    import nanosome.flow.stateMachine.controller.StateMachineControllerEvent;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    import org.flexunit.Assert;

    import tests.misc.ButtonSignals;

    public class StateMachineTest
    {
        private var _normalState:State;
        private var _overedState:State;
        private var _overedAndPressedState:State;
        private var _pressedOutsideState:State;

        private var _normalToOveredTransition:Transition;
        private var _overedToNormalTransition:Transition;
        private var _overedToPressedTransition:Transition;
        private var _pressedToOveredTransition:Transition;
        private var _pressedToPressedOutsideTransition:Transition;
        private var _pressedOutsideToPressedTransition:Transition;
        private var _pressedOutsideToNormalTransition:Transition;

        private var _stateMachine:StateMachine;

        [Before]
        public function ConfigureStateMachine():void
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
        public function StateMachineTriggeringStateTest():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var controller:StateMachineController = new StateMachineController(_stateMachine, s);
            s.mouseOver.fire();
            s.mouseDown.fire();
            s.mouseOver.fire();

            Assert.assertEquals(controller.getCurrentState(), _overedAndPressedState);
        }

        private var _event:StateMachineControllerEvent;

        [Test]
        public function StateMachineFiringControllerEventTest():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var controller:StateMachineController = new StateMachineController(_stateMachine, s);

            controller.addEventListener(StateMachineControllerEvent.STATE_CHANGED, onSMControllerEvent);
            s.mouseOver.fire();

            Assert.assertEquals(_event.transition, _normalToOveredTransition);
            Assert.assertEquals(_event.oldState, _normalState);

            s.mouseDown.fire();

            Assert.assertEquals(_event.transition, _overedToPressedTransition);
            Assert.assertEquals(_event.oldState, _overedState);
        }

        private function onSMControllerEvent(event:StateMachineControllerEvent):void
        {
            _event = event;
        }

        [Test]
        public function SharedSignalsLayerTest():void
        {
            var s:ButtonSignals = new ButtonSignals();
            var controllerOne:StateMachineController = new StateMachineController(_stateMachine, s);
            var controllerTwo:StateMachineController = new StateMachineController(_stateMachine, s);

            s.mouseOver.fire();

            Assert.assertEquals(controllerOne.getCurrentState(), controllerTwo.getCurrentState(), _overedState);
        }

        [Test]
        public function SeparatedSignalsLayerTest():void
        {
            var sOne:ButtonSignals = new ButtonSignals();
            var sTwo:ButtonSignals = new ButtonSignals();
            var controllerOne:StateMachineController = new StateMachineController(_stateMachine, sOne);
            var controllerTwo:StateMachineController = new StateMachineController(_stateMachine, sTwo);

            sOne.mouseOver.fire();
            sTwo.mouseOver.fire();
            sTwo.mouseDown.fire();

            Assert.assertEquals(controllerOne.getCurrentState(), _overedState);
            Assert.assertEquals(controllerTwo.getCurrentState(), _overedAndPressedState);
        }

    }
}
