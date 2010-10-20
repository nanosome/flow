// @license@
package  
{
	import nanosome.flow.stateMachine.logic.Transition;
	import net.antistatic.logging.LogFactory;
	import net.antistatic.logging.ILogger;
	import nanosome.flow.builders.StateMachineBuilder;
	
	import nanosome.flow.stateMachine.StateMachine;
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.AbstractSignal;
	
	/**
	 * @author dimitri.fedorov
	 */
	public class SampleStateMachine extends StateMachineBuilder 
	{
		/*
		 * We need to declare all components as public:
		 *  - states, to wire with visual states / values
		 *  - signals, to wire with events / bindables
		 *  - transitions, to wire with easings / transitions
		 */
		 
		// states
		public var overed:State; 
		public var pressed:State;
		public var pressedOutside:State;
		
		// signals
		public var mouseUp:AbstractSignal;
		public var mouseDown:AbstractSignal;
		public var mouseOver:AbstractSignal;
		public var mouseOut:AbstractSignal;
		
		// transitions
		public var fromNormalToOvered:Transition; 
		public var fromOveredToNormal:Transition;
		public var fromOveredToPressed:Transition;
		public var fromPressedToOvered:Transition;
		public var fromPressedToPressedOutside:Transition;
		public var fromPressedOutsideToPressed:Transition;
		public var fromPressedOutsideToNormal:Transition;

		private var _logger:ILogger;
		
		public function SampleStateMachine()
		{
			_logger = LogFactory.getLogger(this);
			createStateMachine();		
		}
		
		public function createStateMachine():StateMachine 
		{
			fromNormalToOvered = _is(
				from(normal).to(overed).by(mouseOver),
				backIs(fromOveredToNormal).by(mouseOut)
			);
				
			fromOveredToPressed = _is(
				from(overed).to(pressed).by(mouseDown),
				backIs(fromPressedToOvered).by(mouseOut)
			);
			
			fromPressedToPressedOutside = _is( 
				from(pressed).to(pressedOutside).by(mouseOut),
				backIs(fromPressedOutsideToPressed).by(mouseOver)
			);
				
			fromPressedOutsideToNormal = _is(from(pressedOutside).to(normal).by(mouseUp));
			
			_logger.info(overed.id);
			return getContent();		
		}

		
	}
}
