package nanosome.flow.visualizing.ticking
{
    import nanosome.flow.visualizing.*;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer;

    /**
     * This class produces ticks with some regularity.
     * Every tick has it delta - offset from last tick.
     * Delta usually is a number of milliseconds lasted since last tick,
     * but it can be any unit used in computing visualizer steps.
     */
    public class TickGenerator extends Sprite implements ITickGenerator
    {

        private var _isRunning:Boolean;
        private var _prevTimer:int;

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        public function TickGenerator()
        {
        }

        public function start():void
        {
            if (_isRunning)
                return;
            _isRunning = true;
            _prevTimer = getTimer();
            addEventListener(Event.ENTER_FRAME, onEnterFrame)
        }

        public function stop():void
        {
            if (!_isRunning)
                return;
            _isRunning = false;
            removeEventListener(Event.ENTER_FRAME, onEnterFrame)
        }

        private function onEnterFrame(event:Event):void
        {
            var nowTimer:int = getTimer();
            dispatchEvent(new TickGeneratorEvent(TickGeneratorEvent.TICK_UPDATE, nowTimer - _prevTimer));
            _prevTimer = nowTimer;
        }

        public function get isRunning():Boolean
        {
            return _isRunning;
        }
    }
}
