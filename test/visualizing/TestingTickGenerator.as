package visualizing
{
    import flash.events.EventDispatcher;

    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    public class TestingTickGenerator extends EventDispatcher implements ITickGenerator
    {
        private var _isRunning:Boolean = false;
        
        public function TestingTickGenerator()
        {
        }

        public function start():void
        {
            _isRunning = true;
        }

        public function stop():void
        {
            _isRunning = false;
        }

        public function makeTicks(delta:Number):void
        {
            dispatchEvent(new TickGeneratorEvent(TickGeneratorEvent.TICK_UPDATE, delta));
        }

        public function get isRunning():Boolean
        {
            return _isRunning;
        }
    }
}
