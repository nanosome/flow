// @license@
package nanosome.flow.visualizing
{
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.processor.StateMachineProcessor;
    import nanosome.flow.stateMachine.processor.StateMachineProcessorEvent;

    /**
     * This class is meant to control visualizers, based on StateMachine behavior.
     * Difference between visualizer and StateMachine is that state machine reacts
     * to signals by immediately switching states (transitions has zero duration),
     * and visualizer performs switching in steps (whatever time or frame based).
     */
    public class VisualizerManager extends StateMachineProcessor
    {

        private var _visualizers:Vector.<Visualizer>;

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        public function VisualizerManager(stateMachine:StateMachine, signals:AbstractSignalSet)
        {
            super(stateMachine, signals);
            _visualizers = new Vector.<Visualizer>();

            // instead of overriding protected method handling transitions, just add
            // event listener to ourselves - it will allow us easily decouple (if needed)
            // from StateMachineProcessor
            addEventListener(StateMachineProcessorEvent.STATE_CHANGED, onStateChanged);
        }


        public function addVisualizer(visualizer:Visualizer):void
        {
            _visualizers.push(visualizer);
            visualizer.setInitialState(_currentState);
        }

        private function onStateChanged(event:StateMachineProcessorEvent):void
        {
            var v:Visualizer;
            for each (v in _visualizers)
            {
                v.setTransition(event.transition);
            }
        }
    }
}
