package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.easing.EasingLine;
    import nanosome.flow.easing.EasingLineRunner;
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class Visualizer
    {
        private var _transform:IVisualizerTransform;

        private var _values:Dictionary;
        private var _easings:Dictionary;

        private var _prevTransition:Transition;
        private var _initialValue:Number;
        private var _isEndValueApplied:Boolean;
        private var _runner:EasingLineRunner;
        
        
        public function Visualizer(transform:IVisualizerTransform)
        {
            _transform = transform;
            _values = new Dictionary();
            _easings = new Dictionary();
        }

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

        public function checkMissingStates(stateMachine:StateMachine):Vector.<State>
        {
            var res:Vector.<State> = new Vector.<State>();
            var states:Vector.<State> = stateMachine.getStates();
            
            for each (var state:State in states)
            {
                if (_values[state] == null)
                    res.push(state);
            }
            return res;
        }

        public function checkMissingTransitions(stateMachine:StateMachine):Vector.<Transition>
        {
            var res:Vector.<Transition> = new Vector.<Transition>();
            var transitions:Vector.<Transition> = stateMachine.getTransitions();
            var transition:Transition;

            for (var transitionObj:Object in _easings)
            {
                transition = Transition(transitionObj);
                if (transitions.indexOf(transition) < 0)
                    res.push(transition);
            }
            return res;
        }

    }
}
