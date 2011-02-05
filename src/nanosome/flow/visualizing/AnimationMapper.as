package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;


    public class AnimationMapper
    {
        private var _animator:BaseAnimator;

        private var _values:Dictionary;
        private var _easings:Dictionary;

        private var _prevTransition:Transition;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function AnimationMapper(animator:BaseAnimator)
        {
            _animator = animator;
            _values = new Dictionary();
            _easings = new Dictionary();
        }

        public function mapValue(state:State, value:Number):void
        {
            _values[state] = value;
        }

        public function mapTransition(transition:Transition, timedEasing:TimedEasing):void
        {
            _easings[transition] = timedEasing;
        }

        public function setTransition(transition:Transition):void
        {

            var isReversing:Boolean = ( _prevTransition &&
                transition.source == _prevTransition.target &&
                transition.target == _prevTransition.source
            );

            var easing:TimedEasing = _easings[transition];

            if (isReversing)
                _animator.reverseTo(easing._easing, easing._duration);
            else
                _animator.switchTo(easing._easing, easing._duration, _values[transition.source], _values[transition.target]);

            _prevTransition = transition;
        }

        public function setInitialState(state:State):void
        {
            _animator.setInitialValue(_values[state]);
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

        protected function getEasingsList():Dictionary
        {
            return _easings;
        }

        protected function getValuesList():Dictionary
        {
            return _values;   
        }

        public function hasIdenticalMappingsWith(target:AnimationMapper):Boolean
        {
            var targetValues:Dictionary = target.getValuesList();
            var targetEasings:Dictionary = target.getEasingsList();

            var stateObj:Object;
            for (stateObj in targetValues)
            {
                if (targetValues[stateObj] !== _values[stateObj])
                    return false
            }

            var transitionObj:Object;
            for (transitionObj in targetEasings)
            {
                if (targetEasings[transitionObj] !== _easings[transitionObj])
                    return false
            }

            for (stateObj in _values)
            {
                if (_values[stateObj] !== targetValues[stateObj])
                    return false
            }

            for (transitionObj in _easings)
            {
                if (_easings[transitionObj] !== targetEasings[transitionObj])
                    return false
            }

            return true;
        }
    }
}
