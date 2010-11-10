// @license@
package nanosome.flow.stateMachine
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.SignalEvent;
    import nanosome.flow.visualizing.EasingBuilder;
    import nanosome.flow.visualizing.ValuesBuilder;
    import nanosome.flow.visualizing.Visualizer;

    /**
	 * 
	 */
	public class StateMachineController extends EventDispatcher 
	{
		// Messages constants for events
		public static const STATE_CHANGED:String 	= "stateChanged"; 
			
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

        private var _visualizers:Vector.<Visualizer>;

				
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
		public function StateMachineController(stateMachine:StateMachine, signals:AbstractSignalSet)
		{
			_stateMachine = stateMachine;
            _signals = signals;
            _signals.addEventListener(SignalEvent.SIGNAL_FIRED, onSignalFired);
		}

        public function onSignalFired(event:SignalEvent):void
        {
            handle(event.signalCode);
        }

        public function addVisualization(valuesBuilder:ValuesBuilder, easingBuilder:EasingBuilder):void
        {
            _visualizers.push(new Visualizer(valuesBuilder, easingBuilder));
        }

		/**
		 *  Performing check for State change. 
		 *  Changes current action and state, if conditions are met.
		 *  
		 *  @return True, if conditions are met.
		 */		
		private function handle(eventCode:String):Boolean
		{	
		    if(_currentState.hasTransition(eventCode))
		    {
		    	transitionTo(_currentState.targetState(eventCode));
		    	return true;
		    }
		    return false;
		}
		
		/**
	 	 *  Sets new state. 
	 	 *  
	 	 *  @param newState State to set
	 	 */			
		private function transitionTo(target:State):void
		{
			_currentState = target;
			dispatchEvent(new Event(STATE_CHANGED));
		}
	
	}
}
