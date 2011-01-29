// @license@
package nanosome.flow.stateMachine.processor
{
    import flash.profiler.profile;

    import nanosome.flow.stateMachine.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.SignalEvent;
    import nanosome.flow.stateMachine.logic.Transition;

    public class StateMachineProcessor extends EventDispatcher
    { // TODO: Rename it to StateMachine, drop StateMachine
        /**
         * @private
         * Holds a reference to current state
         */
        protected var _currentState:State;

        /**
         * @private
         * Holds a reference to state machine currently working with
         */
        private var _stateMachine:StateMachine;

        /**
         * @private
         * Holds a reference to signals set
         */
        private var _signals:AbstractSignalSet;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  Constructor
         */
        public function StateMachineProcessor(stateMachine:StateMachine, signals:AbstractSignalSet)
        {
            _stateMachine = stateMachine;
            _currentState = stateMachine.getInitialState();
            _signals = signals;
            _signals.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
        }

        private function onSignalFired(event:SignalEvent):void 
        {
            handle(event.signalID);
        }

        
        protected function handle(eventCode:String):Boolean
        {
            if (!_stateMachine.hasTransitionFromStateForForEvent(_currentState, eventCode))
                return false;

            var transition:Transition = _stateMachine.getTransitionFromStateForEvent(_currentState,eventCode);
            var oldState:State = _currentState;
            _currentState = transition.target;
            dispatchEvent(new StateMachineProcessorEvent(oldState, transition));
            return true;
        }


        public function getCurrentState():State
        {
            return _currentState;
        }
    
    }
}
