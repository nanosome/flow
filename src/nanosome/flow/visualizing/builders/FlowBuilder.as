package nanosome.flow.visualizing.builders
{
    import nanosome.flow.signals.AbstractSignalSet;
import nanosome.flow.stateMachine.State;
import nanosome.flow.stateMachine.Transition;
import nanosome.flow.visualizing.TargetPropertyVisualizer;
    import nanosome.flow.visualizing.TargetPropertyVisualizerManager;

    public class FlowBuilder extends AbstractFlowBuilder
    {
        protected function defineStatesAndTransitions(state:State, transition:Transition):void
        {
             throw new Error("This method should be overriden");
        }

        override protected function _defineStatesAndTransitions(state:State, transition:Transition, configObject:Object):void
        {
            defineStatesAndTransitions(state, transition);
        }
    }
}
