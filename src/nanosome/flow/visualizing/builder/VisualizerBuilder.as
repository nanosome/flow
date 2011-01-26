package nanosome.flow.visualizing.builder
{
    import nanosome.flow.easing.TimedEasing;
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.visualizing.Visualizer;
    import nanosome.flow.visualizing.controller.VisualizerController;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class VisualizerBuilder extends Visualizer
    {
        private var _parentalController:VisualizerController;

        public function VisualizerBuilder(transform:IVisualizerTransform, parentalController:VisualizerController)
        {
            super(transform);
            _parentalController = parentalController;
        }

        public function state(state:State, value:Number):VisualizerBuilder
        {
            return this;
        }

        public function transition(transition:Transition, value:TimedEasing):VisualizerBuilder
        {
            return this;
        }

        public function transitionsAs(targetBuilder:VisualizerBuilder):VisualizerBuilder
        {
            return this;
        }

        public function valuesAs(targetBuilder:VisualizerBuilder):VisualizerBuilder
        {
            return this;
        }

        public function activate():void
        {
            _parentalController.addVisualizer(this);
        }

        //--------------------------------------------------------------------------
        //
        //  internal methods
        //
        //--------------------------------------------------------------------------


    }
}
