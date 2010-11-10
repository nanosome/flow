// @license@
package samples.stateMachines
{
	import nanosome.flow.stateMachine.logic.Transition;
	import net.antistatic.logging.LogFactory;
	import net.antistatic.logging.ILogger;
	import nanosome.flow.stateMachine.StateMachineBuilder;
	
	import nanosome.flow.stateMachine.StateMachine;
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.signals.Signal;

    import samples.signalSets.ToggleSignals;

    /**
	 * @author dimitri.fedorov
	 */
	public class BinaryStateMachine extends StateMachineBuilder
	{
		// states
		public var active:State;
		public var passive:State;

		// transitions
		public var fromActiveToPassive:Transition;
		public var fromPassiveToActive:Transition;

        private var _signals:ToggleSignals;

		private var _logger:ILogger;
		
		public function BinaryStateMachine(signals:ToggleSignals)
		{
            passive = new State("passive");
            _signals = signals;
            super(passive);
			_logger = LogFactory.getLogger(this);
			createStateMachine();		
		}
		
		public function createStateMachine():StateMachine 
		{
			fromPassiveToActive = _is(
				from(passive).to(active).by(_signals.turnOn),
				backIs(fromActiveToPassive).by(_signals.turnOff)
			);

			return getContent();		
		}
		
	}
}
