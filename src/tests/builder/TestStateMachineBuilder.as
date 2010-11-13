package tests.builder
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.StateMachineBuilder;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;

    import tests.stateMachine.ButtonSignals;

    public class TestStateMachineBuilder extends StateMachineBuilder
	{
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

        public function getNewSignalsSet():ButtonSignals
        {
            return new ButtonSignals();
        }
		
		override protected function configureStateMachine():StateMachine
		{
            var signals:ButtonSignals = getNewSignalsSet();

			fromNormalToOvered = _is(
				from(normal).to(overed).by(signals.mouseOver),
				backIs(fromOveredToNormal).by(signals.mouseOut)
			);
				
			fromOveredToPressed = _is(
				from(overed).to(pressed).by(signals.mouseDown),
				backIs(fromPressedToOvered).by(signals.mouseOut)
			);
			
			fromPressedToPressedOutside = _is( 
				from(pressed).to(pressedOutside).by(signals.mouseOut),
				backIs(fromPressedOutsideToPressed).by(signals.mouseOver)
			);
				
			fromPressedOutsideToNormal = _is(from(pressedOutside).to(normal).by(signals.mouseUp));

			return new StateMachine(normal);
		}

	}
}
