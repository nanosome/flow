package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    public class AnimationMapping
    {
        internal var _values:Dictionary;
        internal var _easings:Dictionary;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function AnimationMapping()
        {
            _values = new Dictionary();
            _easings = new Dictionary();
        }

        public function mapValue(state:State, value:*):void
        {
            _values[state] = value;
        }

        public function mapTransition(transition:Transition, timedEasing:TimedEasing):void
        {
            _easings[transition] = timedEasing;
        }

        //--------------------------------------------------------------------------
        //
        //  Utility methods
        //
        //--------------------------------------------------------------------------

        public function checkMissingStates(stateMachine:StateMachine):Vector.<State>
        {
            var res:Vector.<State> = new Vector.<State>();
            
            for each (var state:State in stateMachine.states)
            {
                if (_values[state] == null)
                    res.push(state);
            }
            return res;
        }

        public function checkMissingTransitions(stateMachine:StateMachine):Vector.<Transition>
        {
            var res:Vector.<Transition> = new Vector.<Transition>();

            for each (var transition:Transition in stateMachine.transitions)
            {
                if (_easings[transition] == null)
                    res.push(transition);
            }
            return res;
        }

        internal function getEasingForTransition(transition:Transition):TimedEasing
        {
            return _easings[transition];
        }

        internal function getValueForState(state:State):*
        {
            return _values[state];
        }
    }
}
