package sample
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import stateMachines.buttons.ButtonStateMachine;
    import stateMachines.misc.BinaryStateMachine;

    public class ToggleButton
    {
        // ===== this stuff will be extended

        // at first, we have to create SignalsChannel, one per container class
        // (in this case, its button)
        var btSignals:ButtonSignals = new ButtonSignals(); // we can use factory here as well

        //
        var tgSignals:ToggleSignals = new ToggleSignals();

        private function onMouseOver(event:MouseEvent):void
        {
            btSignals.mouseOver.fire(); // fire mouseOver signal
        }

        private function onMouseDown(event:MouseEvent):void
        {
            btSignals.mouseDown.fire(); // fire mouseOver signal
        }

        // ===== end of extendable stuff


        private var _playIcon:Sprite;
        private var _hilite:Sprite;
        private var _pauseIcon:Sprite;

        public function ToggleButton()
        {
            // this state machine describes basic button behavior
            var bt:ButtonStateMachine = new ButtonStateMachine();

            // and this one - its toggling on/off
            var tg:BinaryStateMachine = new BinaryStateMachine();

            // defining state machine controller and wiring it to signals channel
            var smController = new VSMController(sm, signals);

            // preparing visualizers
            var iconSwitchViz:IElementVisualizer = new TwoStateVisualizer(_playIcon, _pauseIcon);
            // atm easings and values are not separated, although it may make sense to use them separately
            iconSwitchViz.value(sm.overed, 1).transition.

            var hiliteViz:IElementVisualizer = new SimpleVisualizer(_hilite, AlphaVisualization);
            var iconScaleViz:IElementVisualizer = new SimpleVisualizer(new VisualGroup(), ScaleVisualization);
            var scaleViz:SMVisualizer = new SMVisualizer();

            scaleViz.target(_playIcon)
        }
    }
}
