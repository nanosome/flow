package samples.stateMachines
{
	import nanosome.flow.stateMachine.logic.Transition;
	import net.antistatic.logging.LogFactory;
	import net.antistatic.logging.ILogger;
	import nanosome.flow.stateMachine.StateMachineBuilder;
	
	import nanosome.flow.stateMachine.StateMachine;
	import nanosome.flow.stateMachine.logic.State;

    import samples.signalSets.ButtonSignals;

    /**
	 * @author dimitri.fedorov
	 */
	public class ButtonStateMachine extends StateMachineBuilder
	{
		/*
		 * We need to declare all components as public:
		 *  - states, to wire with visual states / values
		 *  - signals, to wire with events / bindables
		 *  - transitions, to wire with easings / transitions
		 */
		 
		// states
        public var normal:State;
		public var overed:State; 
		public var pressed:State;
		public var pressedOutside:State;

		// transitions
		public var fromNormalToOvered:Transition; 
		public var fromOveredToNormal:Transition;
		public var fromOveredToPressed:Transition;
		public var fromPressedToOvered:Transition;
		public var fromPressedToPressedOutside:Transition;
		public var fromPressedOutsideToPressed:Transition;
		public var fromPressedOutsideToNormal:Transition;

        private var _signals:ButtonSignals;

		private var _logger:ILogger;

		public function ButtonStateMachine()
		{
            _signals = new ButtonSignals();
            normal = new State("si.Normal");
            super(normal);
			_logger = LogFactory.getLogger(this);
			createStateMachine();		
		}

        public function getSignalsClass():Class
        {
            return ButtonSignals;
        }
		
		public function createStateMachine():StateMachine 
		{
			fromNormalToOvered = _is(
				from(normal).to(overed).by(_signals.mouseOver),
				backIs(fromOveredToNormal).by(_signals.mouseOut)
			);
				
			fromOveredToPressed = _is(
				from(overed).to(pressed).by(_signals.mouseDown),
				backIs(fromPressedToOvered).by(_signals.mouseOut)
			);
			
			fromPressedToPressedOutside = _is( 
				from(pressed).to(pressedOutside).by(_signals.mouseOut),
				backIs(fromPressedOutsideToPressed).by(_signals.mouseOver)
			);
				
			fromPressedOutsideToNormal = _is(from(pressedOutside).to(normal).by(_signals.mouseUp));
			
			_logger.info(overed.id);
			return getContent();		
		}

	}
}
