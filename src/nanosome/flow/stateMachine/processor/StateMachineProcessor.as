// @license@
package nanosome.flow.stateMachine.processor
{
    import flash.events.EventDispatcher;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.SignalEvent;
    import nanosome.flow.stateMachine.Transition;

    /**
     * Unlike <code>StateMachine</code>, which is stateless and describes only logic and behavior,
     * this class is actually has a state. It takes <code>StateMachine</code> for logic
     * and <code>AbstractSignalSet</code> as input for reaction.
     * 
     * Currently active state can be obtained with <code>getCurrentState</code> method.
     *
     *  @see StateMachine
     *  @see AbstractSignalSet
     *
     *  @author dimitri.fedorov
     */
    public class StateMachineProcessor extends EventDispatcher
    {
        /**
         * @private
         * Holds a reference to current state.
         */
        protected var _currentState:State;

        /**
         * @private
         * Holds a reference to state machine currently working with.
         */
        private var _stateMachine:StateMachine;

        /**
         * @private
         * Holds a reference to signals set.
         */
        private var _signals:AbstractSignalSet;

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        /**
         * Creates new instance of <code>StateMachineProcessor</code>.
         *
         * @param stateMachine <code>StateMachine</code>, logic to work with.
         * @param signals <code>SignalSet</code> to react to.
         */
        public function StateMachineProcessor(stateMachine:StateMachine, signals:AbstractSignalSet)
        {
            _stateMachine = stateMachine;
            _currentState = stateMachine.getInitialState();
            _signals = signals;
            _signals.addEventListener(SignalEvent.SIGNAL_FIRED, function(e:SignalEvent) { handle(e.signalID); });
        }

        protected function handle(eventCode:String):Boolean
        {
            if (!_stateMachine.hasTransitionFromStateForSignal(_currentState, eventCode))
                return false;

            var transition:Transition = _stateMachine.getTransitionFromStateForSignal(_currentState,eventCode);
            var oldState:State = _currentState;
            _currentState = transition.target;
            dispatchEvent(new StateMachineProcessorEvent(oldState, transition));
            return true;
        }

        /**
         * 
         * @return currently active <code>State</code>
         */
        public function getCurrentState():State
        {
            return _currentState;
        }
    
    }
}
