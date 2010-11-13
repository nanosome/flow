package nanosome.flow.stateMachine.controller
{
    import flash.events.Event;

    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    public class StateMachineControllerEvent extends Event
    {
		// Messages constants for events
		public static const STATE_CHANGED:String 	= "stateChanged";

        private var _oldState:State;
        private var _transition:Transition;

        public function StateMachineControllerEvent(oldState:State, transition:Transition)
        {
            _oldState = oldState;
            _transition = transition;
            super(STATE_CHANGED);
        }

        public function get oldState():State
        {
            return _oldState;
        }

        public function get transition():Transition
        {
            return _transition;
        }
    }
}
