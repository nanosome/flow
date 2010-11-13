package tests.stateMachine
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.controller.StateMachineController;

    import nanosome.flow.stateMachine.controller.StateMachineControllerEvent;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    import org.flexunit.Assert;

    public class StateMachineTest
    {
        private var _signals:ButtonSignals;

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
            _signals = new ButtonSignals();

            _normalState = new State("normal");
            _overedState = new State("overed");
            _overedAndPressedState = new State("overedAndPressed");
            _pressedOutsideState = new State("pressedOutside");

            _stateMachine = new StateMachine(_normalState);

            _normalToOveredTransition =
                    _normalState.addTransition(_signals.mouseOver, _overedState);

            _overedToNormalTransition =
                    _overedState.addTransition(_signals.mouseOut, _normalState);

            _overedToPressedTransition =
                    _overedState.addTransition(_signals.mouseDown, _overedAndPressedState);

            _pressedToOveredTransition =
                    _overedAndPressedState.addTransition(_signals.mouseUp, _overedState);

            _pressedToPressedOutsideTransition =
                _overedAndPressedState.addTransition(_signals.mouseOut, _pressedOutsideState);

            _pressedOutsideToPressedTransition =
                _pressedOutsideState.addTransition(_signals.mouseOver, _overedAndPressedState);

            _pressedOutsideToNormalTransition =
                _pressedOutsideState.addTransition(_signals.mouseUp, _normalState);
        }

        [Test]
        public function StateMachineTriggeringStateTest():void
        {
            var controller:StateMachineController = new StateMachineController(_stateMachine, _signals);
            _signals.mouseOver.fire();
            _signals.mouseDown.fire();
            _signals.mouseOver.fire();

            Assert.assertEquals(controller.getCurrentState(), _overedAndPressedState);
        }

        private var _event:StateMachineControllerEvent;

        [Test]
        public function StateMachineFiringControllerEventTest():void
        {
            var controller:StateMachineController = new StateMachineController(_stateMachine, _signals);

            controller.addEventListener(StateMachineControllerEvent.STATE_CHANGED, onSMControllerEvent);
            _signals.mouseOver.fire();
            _signals.mouseDown.fire();

            Assert.assertEquals(_event.transition, _overedToPressedTransition);
            Assert.assertEquals(_event.oldState, _overedState);
        }

        private function onSMControllerEvent(event:StateMachineControllerEvent):void
        {
            _event = event;
        }
    }
}
