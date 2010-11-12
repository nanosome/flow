package nanosome.flow.signals
{
    import flash.events.Event;

    public class SignalEvent extends Event
    {
        public static const SIGNAL_FIRED:String = "signalFired";

        private var _signalID:String;

        public function SignalEvent(signal:Signal)
        {
            super(SIGNAL_FIRED);
            _signalID = signal.id;
        }

        public function get signalID():String
        {
            return _signalID;
        }
    }
}
