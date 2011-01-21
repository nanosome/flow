// @license@
package nanosome.flow.stateMachine.processor
{
    import nanosome.flow.stateMachine.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.SignalEvent;
    import nanosome.flow.stateMachine.logic.Transition;

    /**
	 * 
	 */
	public class StateMachineProcessor extends EventDispatcher
	{
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
		 *  
		 *  @param initialState Initial state to start with
		 */			
		public function StateMachineProcessor(stateMachine:StateMachine, signals:AbstractSignalSet)
		{
			_stateMachine = stateMachine;
            _currentState = stateMachine.getInitialState();
            _signals = signals;
            // Frankly, we can add type checking for signals set here to match
            // incoming signals parameter type with that of used for stateMachine
            // but this coupling is no good, i guess, because
            // signals from different sets but with same signal ID should be
            // treated equally
            _signals.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
		}

        public function onSignalFired(event:SignalEvent):void
        {
            handle(event.signalID);
        }

		/**
		 *  Performing check for State change. 
		 *  Changes current action and state, if conditions are met.
		 *  
		 *  @return True, if conditions are met.
		 */		
		protected function handle(eventCode:String):Boolean
		{
		    if(_currentState.hasTransitionForEvent(eventCode))
		    {
		    	handleTransition(_currentState.transitionForEvent(eventCode));
		    	return true;
		    }
		    return false;
		}
		
		/**
	 	 *  Sets new state. 
	 	 *  
	 	 *  @param newState State to set
	 	 */			
		protected function handleTransition(transition:Transition):void
		{
            var oldState:State = _currentState;
			_currentState = transition.target;
			dispatchEvent(new StateMachineProcessorEvent(oldState, transition));
		}

        public function getCurrentState():State
        {
            return _currentState;
        }
	
	}
}
