package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    public class AnimationMapping
    {
        private var _values:Dictionary;
        private var _easings:Dictionary;

        private var _states:Array;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function AnimationMapping()
        {
            _states = [];
            _values = new Dictionary();
            _easings = new Dictionary();
        }

        public function mapValue(state:State, value:*):void
        {
            _states.push(state);
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
            var res:* = _values[state];
            return _values[state];
        }

        public function hasIdenticalMappingsWith(target:AnimationMapping):Boolean
        {
            var targetValues:Dictionary = target._values;
            var targetEasings:Dictionary = target._easings;

            var stateObj:Object;
            for (stateObj in targetValues)
            {
                if (targetValues[stateObj] != _values[stateObj])
                    return false
            }

            var transitionObj:Object;
            for (transitionObj in targetEasings)
            {
                if (!areTimedEasingsEqual(targetEasings[transitionObj], _easings[transitionObj]))
                    return false
            }

            for (stateObj in _values)
            {
                if (_values[stateObj] != targetValues[stateObj])
                    return false
            }

            for (transitionObj in _easings)
            {
                if (!areTimedEasingsEqual(_easings[transitionObj], targetEasings[transitionObj]))
                    return false
            }

            return true;
        }

        private function areTimedEasingsEqual(easingOne:TimedEasing, easingTwo:TimedEasing):Boolean
        {
            return (easingOne._duration == easingTwo.duration && easingOne._easing  == easingTwo._easing);
        }
    }
}
