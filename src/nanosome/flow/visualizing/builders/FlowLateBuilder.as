package nanosome.flow.visualizing.builders
{
    import nanosome.flow.signals.AbstractSignalSet;
import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.TargetPropertyVisualizer;
    import nanosome.flow.visualizing.TargetPropertyVisualizerManager;

    public class FlowLateBuilder extends AbstractFlowBuilder
    {
        private var _initialized:Boolean;

        public function FlowLateBuilder()
        {
            prepare();
            _initialized = false;
        }

        public function initialize(configObject:Object):void
        {
            _defineAllStatesAndTransitions(configObject);
            validate();
            _initialized = true;
        }

        public function get initialized():Boolean
        {
            return _initialized;
        }

        protected function defineStatesAndTransitions(state:State, transition:Transition, $:Object):void
        {
             throw new Error("This method should be overriden");
        }

        override protected function _defineStatesAndTransitions(state:State, transition:Transition, configObject:Object):void
        {
            defineStatesAndTransitions(state, transition, configObject);
        }
    }
}
