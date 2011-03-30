// @license@
package nanosome.flow.stateMachine.builder
{
    import nanosome.flow.signals.Signal;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.Transition;

    final public class TransitionBuilder
    {
        private var _sourceState:State;
        private var _signal:Signal;
        private var _targetState:State;
        private var _stateMachine:StateMachine;

        public function TransitionBuilder(stateMachine:StateMachine)
        {
            _stateMachine = stateMachine;
        }

        public function get _():Transition
        {
            checkTransition();
            return _stateMachine.addTransition(_sourceState, _signal.id, _targetState);
        }

        public function from(state:State):TransitionBuilder
        {
            _sourceState = state;
            return this;
        }

        public function by(signal:Signal):TransitionBuilder
        {
            _signal = signal;
            return this;
        }

        public function to(state:State):TransitionBuilder
        {
            _targetState = state;
            return this;
        }

        private function checkTransition():void
        {
            if (!_sourceState)
                throw new Error("Source state is not defined!");

            if (!_targetState)
                throw new Error("Target state is not defined!");

            if (!_signal)
                throw new Error("Signal for transition is not defined!");
        }

        public function back(backTransition:Transition, backSignal:Signal):TransitionBuilder
        {
            checkTransition();
            _stateMachine.defineTransition(backTransition, _targetState, backSignal.id, _sourceState);
            return this;
        }

    }
}
