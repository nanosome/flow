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
    public class TargetPropertyVisualizerManager extends StateMachineProcessor
    {

        private var _propertyVisualizers:Vector.<TargetPropertyVisualizer>;

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        public function TargetPropertyVisualizerManager(stateMachine:StateMachine, signals:AbstractSignalSet)
        {
            super(stateMachine, signals);
            _propertyVisualizers = new Vector.<TargetPropertyVisualizer>();

            // instead of overriding protected method handling transitions, just add
            // event listener to ourselves - it will allow us easily decouple (if needed)
            // from StateMachineProcessor
            addEventListener(StateMachineProcessorEvent.STATE_CHANGED, onStateChanged);
        }


        public function addTargetPropertyVisualizer(visualizer:TargetPropertyVisualizer):void
        {
            _propertyVisualizers.push(visualizer);
            visualizer.setInitialState(_currentState);
        }

        private function onStateChanged(event:StateMachineProcessorEvent):void
        {
            var v:TargetPropertyVisualizer;
            for each (v in _propertyVisualizers)
            {
                v.setTransition(event.transition);
            }
        }
    }
}
