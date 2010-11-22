package nanosome.flow.visualizing
{
    import nanosome.flow.stateMachine.logic.State;
    import nanosome.flow.stateMachine.logic.Transition;
    import nanosome.flow.visualizing.transforms.IVisualizerTransform;

    public class Visualizer
    {

        /**
         * Visualizer consists of single target + transformer pair
         * and two hashmaps - one for values at StateMachine states
         * and one for easing lines
         */
        public function Visualizer(transform:IVisualizerTransform)
        {
        }

        public function mapValue(state:State, value:Number):void
        {

        }

        public function mapTransition(transition:Transition, easingLine:EasingLine):void
        {

        }
    }
}
