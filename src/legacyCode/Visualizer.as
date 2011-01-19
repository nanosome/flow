package legacyCode
{
    import flash.utils.Dictionary;

    import nanosome.flow.easingLines.EasingLine;
    import nanosome.flow.easingLines.EasingValuesLine;
    import nanosome.flow.stateMachine.controller.StateMachineController;
    import nanosome.flow.stateMachine.controller.StateMachineControllerEvent;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class Visualizer
    {
        private var _controller:StateMachineController;

        private var _transform:IVisualizerTransform;

        private var _values:Dictionary;
        private var _transitions:Dictionary;

        private var _easingRunner:EasingValuesLine;

        /**
         * Visualizer consists of single target + transformer pair
         * and two hashmaps - one for values at StateMachine states
         * and one for easing lines.
         *
         * Visualizer captures CHANGE_STATE events of its parental state machine controller,
         * getting old state and transition from it, and ...
         */
        public function Visualizer(transform:IVisualizerTransform)
        {
            _transform = transform;
            _values = new Dictionary();
            _transitions = new Dictionary();
        }

        public function mapValue(state:State, value:Number):void
        {
            _values[state] = value;
        }

        public function mapTransition(transition:Transition, easingLine:EasingLine):void
        {
            _values[transition] = easingLine;
        }


        public function setController(controller:StateMachineController):void
        {
            _controller = controller;
            _controller.addEventListener(StateMachineControllerEvent.STATE_CHANGED, onControllerChangedState);

            // applying default values
            _transform.apply(_values[_controller.getCurrentState()]);
        }

        private function onControllerChangedState(event:StateMachineControllerEvent):void
        {

        }

        public function makeStep(delta:Number):void
        {
            _easingRunner.makeStep(delta);
        }

        public function applyTransform():void
        {
            _transform.apply(_easingRunner.value);
        }


    }
}
