package visualizing
{
    import flash.events.EventDispatcher;

    import nanosome.flow.visualizing.ITickGenerator;
    import nanosome.flow.visualizing.TickGeneratorEvent;

    public class TestingTickGenerator extends EventDispatcher implements ITickGenerator
    {
        public function TestingTickGenerator()
        {
        }

        public function stop():void
        {}

        public function start():void
        {}

        public function makeTicks(delta:Number):void
        {
            dispatchEvent(new TickGeneratorEvent(TickGeneratorEvent.TICK_UPDATE, delta));
        }

    }
}
