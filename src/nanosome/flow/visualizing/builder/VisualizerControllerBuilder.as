package nanosome.flow.visualizing.builder
{
    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.visualizing.controller.VisualizerController;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class VisualizerControllerBuilder extends VisualizerController
    {
        public function VisualizerControllerBuilder(stateMachine:StateMachine, signals:AbstractSignalSet)
		{
            super(stateMachine, signals);
        }

        public function visualize(transform:IVisualizerTransform):VisualizerBuilder
        {
            return new VisualizerBuilder(transform, this);
        }

    }
}
