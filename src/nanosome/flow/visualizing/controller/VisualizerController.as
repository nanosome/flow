// @license@
package nanosome.flow.visualizing.controller
{
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.processor.StateMachineProcessor;
    import nanosome.flow.stateMachine.processor.StateMachineProcessorEvent;
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;
    import nanosome.flow.visualizing.Visualizer;

    /**
     * This class is meant to control visualizers, based on StateMachine behavior.
     * Difference between visualizer and StateMachine is that state machine reacts
     * to signals by immediately switching states (transitions has zero duration),
     * and visualizer performs switching in steps (whatever time or frame based).
     */
    public class VisualizerController extends StateMachineProcessor
    {

        private var _visualizers:Array;
        private var _tickGenerator:ITickGenerator;

        /**
         *  Constructor
         */            
        public function VisualizerController(stateMachine:StateMachine, signals:AbstractSignalSet)
        {
            super(stateMachine, signals);
            _visualizers = [];
            _tickGenerator = new TickGenerator();
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);

            // instead of overriding protected method handling transitions, just add
            // event listener to ourselves - it will allow us easily decouple (if needed)
            // from StateMachineProcessor
            addEventListener(StateMachineProcessorEvent.STATE_CHANGED, onStateChanged);
        }

        public function setCustomTickGenerator(tickGenerator:ITickGenerator):void
        {
            _tickGenerator.removeEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _tickGenerator = tickGenerator;
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        public function addVisualizer(visualizer:Visualizer):void
        {
            _visualizers.push(visualizer);
            visualizer.setInitialState(_currentState);
            _tickGenerator.start();
        }

        private function onTickUpdate(event:TickGeneratorEvent):void
        {
            var v:Visualizer;
            var areStepsLeft:Boolean = false;
            for each (v in _visualizers)
            {
                areStepsLeft = v.makeStep(event.delta) || areStepsLeft;
            }
            if (!areStepsLeft)
                _tickGenerator.stop();
        }

        private function onStateChanged(event:StateMachineProcessorEvent):void
        {
            var v:Visualizer;
            for each (v in _visualizers)
            {
                v.setTransition(event.transition);
            }
            _tickGenerator.start();
        }
    }
}
