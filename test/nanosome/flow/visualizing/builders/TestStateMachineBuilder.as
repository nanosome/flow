package nanosome.flow.visualizing.builders
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    import misc.ButtonSignals;

    public class TestStateMachineBuilder extends StateMachineBuilder
    {
        // states
        public var normal:State;
        public var overed:State; 

        // transitions
        public var fromNormalToOvered:Transition; 
        public var fromOveredToNormal:Transition;

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
        }

    }
}
