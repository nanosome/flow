package visualizing.builder.stateMachinesConfig
{
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    import misc.ButtonSignals;

    public class TestActivePassiveSM extends StateMachineBuilder
    {
        // states
        public var passive:State;
        public var active:State;

        // transitions
        public var fromPassiveToActive:Transition;
        public var fromActiveToPassive:Transition;

        public function getNewSignalsSet():ActivePassiveSignals
        {
            return new ActivePassiveSignals();
        }
        
        override protected function configureStateMachine():void
        {
            var signals:ActivePassiveSignals = getNewSignalsSet();

            initialState = passive;

            fromPassiveToActive = _.
                from(passive).to(active).by(signals.setActive).
                back(fromActiveToPassive, signals.setPassive)._;
        }

    }
}
