// @license@
package  
{
	import net.antistatic.logging.LogFactory;
	import net.antistatic.logging.ILogger;
	import nanosome.flow.builders.StateMachineBuilder;
	
	import nanosome.flow.stateMachine.StateMachine;
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.Signal;
	
	/**
	 * @author dimitri.fedorov
	 */
	public class SampleStateMachine extends StateMachineBuilder 
	{
		// states
		public var overed:State; 
		public var pressed:State;
		public var pressedOutside:State;
		
		// signals
		public var mouseUp:Signal;
		public var mouseDown:Signal;
		public var mouseOver:Signal;
		public var mouseOut:Signal;

		private var _logger:ILogger;
		
		public function SampleStateMachine()
		{
			_logger = LogFactory.getLogger(this);
			createStateMachine();		
		}
		
		public function createStateMachine():StateMachine
		{
			from(initial).by(mouseOver).to(overed).back(mouseOut);
			from(overed).by(mouseDown).to(pressed).back(mouseUp);
			from(pressed).by(mouseOut).to(pressedOutside).back(mouseOver);
			from(pressedOutside).by(mouseUp).to(initial);
			
			_logger.info(overed.id);
			return getContent();		
		}

		
	}
}
