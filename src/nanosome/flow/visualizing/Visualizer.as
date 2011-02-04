package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;
    import nanosome.flow.visualizing.TimedEasing;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class Visualizer
    {
        private var _animator:BaseAnimator;

        private var _values:Dictionary;
        private var _easings:Dictionary;

        private var _prevTransition:Transition;
        private var _initialValue:Number;
        private var _isEndValueApplied:Boolean;
        
        
        public function Visualizer(animator:BaseAnimator)
        {
            _animator = animator;
            _values = new Dictionary();
            _easings = new Dictionary();
        }

        //TODO: Left here
        
        public function makeStep(delta:Number):Boolean
        {
            if (!_runner || _isEndValueApplied)
                return false;

            if (!_runner.makeStep(delta))
                _isEndValueApplied = true;

            applyTransform();
            return !_isEndValueApplied;
        }

        public function get value():Number
        {
            return _runner ? _runner.value : _initialValue;
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
            var newEasingLine:EasingLine = EasingLine.createWithTimedEasing(
                _easings[transition], _values[transition.source], _values[transition.target]
            );

            if (!_runner)
            {
                _runner = new EasingLineRunner(newEasingLine);
            }
            else
            {
                var isReversing:Boolean = (
                        transition.source == _prevTransition.target &&
                        transition.target == _prevTransition.source
                );
                _runner.switchToNewEasingLine(newEasingLine, isReversing);
            }
            _prevTransition = transition;
            _isEndValueApplied = false;
            applyTransform();
        }

        public function setInitialState(state:State):void
        {
            _initialValue = _values[state];
            applyTransform();
        }

       public function setPosition(position:Number):void
        {
            if (!_runner)
                throw new Error("You can't invoke this method before easing line runner is defined");
            
            _runner.setPosition(position);
            applyTransform();
        }

        public function applyTransform():void
        {
            _transform.apply(value);
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

        public function hasIdenticalMappingsWith(target:Visualizer):Boolean
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
