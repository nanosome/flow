package stateMachine.builder
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.builders.StateMachineBuilder;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    import misc.ButtonSignals;

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

        override protected function configureStateMachine():void
        {
            var signals:ButtonSignals = getNewSignalsSet();

            initialState = normal;

            fromNormalToOvered = _.
                from(normal).to(overed).by(signals.mouseOver).
                back(fromOveredToNormal, signals.mouseOut)._;
                
            fromOveredToPressed = _.
                from(overed).to(pressed).by(signals.mouseDown).
                back(fromPressedToOvered, signals.mouseUp)._;
            
            fromPressedToPressedOutside = _.
                from(pressed).to(pressedOutside).by(signals.mouseOut).
                back(fromPressedOutsideToPressed, signals.mouseOver)._;

            // TODO: Consider the following syntax
            /*
               define(fromNormalToOvered).by(signals.mouseOver).
               back(fromOveredToNormal, signals.mouseOut);

               also consider more straight builders;

               public const normal: State = createState();
               public const overed: State = createState();

               public const fromNormalToOvered: Transition = createTransition( normal, overed );
            */
                
            fromPressedOutsideToNormal = _.from(pressedOutside).to(normal).by(signals.mouseUp)._;
        }

    }
}
