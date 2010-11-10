package samples
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import mx.effects.easing.Elastic;
    import mx.effects.easing.Linear;

    import nanosome.flow.stateMachine.StateMachineController;

    import samples.signalSets.ButtonSignals;
    import samples.stateMachines.ButtonStateMachine;

    import nanosome.flow.visualizing.EasingBuilder;
    import nanosome.flow.visualizing.ValuesBuilder;
    import nanosome.flow.visualizing.vizualizations.AlphaVisualization;

    public class SimpleButton
    {
        // used signal channels
        protected var _btSignals:ButtonSignals;

        // State machine controllers
        protected var _btSMC:StateMachineController;

        // visuals
        protected var _hitArea:Sprite; // this one is global, because we will use it to access stage

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function SimpleButton()
        {
            // initiating state machines separately, so children classes could use them too
            // your implementation may vary
            initiate();
            initiateMouseHandlers();
        }

        /**
         *  StateMachine -(+SignalsChannel)-> SMController -(+EasingLines,durations)=> SMCEasing
         *  -(+Items,values)=> SMCVisualizers
         */

        protected function initiate():void
        {
            _btSignals = new ButtonSignals(); // we can use factory here as well

            var bt:ButtonStateMachine = new ButtonStateMachine();
            _btSMC = new StateMachineController(bt.getContent(), _btSignals);

            // create easings
            var basicEasing:EasingBuilder = new EasingBuilder();
            basicEasing.forTransition(bt.fromNormalToOvered).easing(Linear.easeInOut).duration(150);
            basicEasing.forTransition(bt.fromOveredToNormal).easing(Linear.easeInOut).duration(150);
            // it is possible to define transition partly...
            basicEasing.forTransition(bt.fromPressedToPressedOutside).and(bt.fromPressedOutsideToPressed).
                duration(50);
            basicEasing.forTransition(bt.fromOveredToPressed).and(bt.fromPressedToOvered).duration(75);

            // and define other part later in the code
            basicEasing.forTransition(bt.fromPressedToPressedOutside).and(bt.fromOveredToPressed).easing(Elastic.easeIn);
            basicEasing.forTransition(bt.fromPressedOutsideToPressed).and(bt.fromPressedToOvered).easing(Elastic.easeOut);
            basicEasing.forTransition(bt.fromPressedOutsideToNormal).easing(Linear.easeOut).duration(100);

            // create visualizers
            var hilite:Sprite = new Sprite();
            var hiliteViz:ValuesBuilder = new ValuesBuilder(new AlphaVisualization(hilite));
            hiliteViz.forState(bt.normal).value(1);
            hiliteViz.forState(bt.overed).value(1);
            hiliteViz.forState(bt.pressed).value(1);
            hiliteViz.forState(bt.pressedOutside).value(1);

            _btSMC.addVisualization(hiliteViz, basicEasing);
        }

        //--------------------------------------------------------------------------
        //
        //  Mouse Handlers
        //
        //--------------------------------------------------------------------------

        protected function initiateMouseHandlers():void
        {
            _hitArea = new Sprite();

            _hitArea.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            _hitArea.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            _hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }

        protected function onMouseOut(event:MouseEvent):void
        {
            _btSignals.mouseOut.fire();
        }

        protected function onMouseOver(event:MouseEvent):void
        {
            _btSignals.mouseOver.fire();
        }

        protected function onMouseDown(event:MouseEvent):void
        {
            _btSignals.mouseDown.fire();
            _hitArea.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
        }

        protected function onMouseUpStage(event:MouseEvent):void
        {
            _hitArea.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
            _btSignals.mouseUp.fire();
        }

    }
}
