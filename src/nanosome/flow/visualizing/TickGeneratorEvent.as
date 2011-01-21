package nanosome.flow.visualizing
{
    import flash.events.Event;

    public class TickGeneratorEvent extends Event
    {
        public static const TICK_UPDATE:String = "tickUpdate";

        private var _delta:Number;

        public function TickGeneratorEvent(type:String, delta:Number)
        {
            super(type);
            _delta = delta;
        }

        public function get delta():Number
        {
            return _delta;
        }
    }
}
