package sample.signalSets
{
    import flash.events.EventDispatcher;

    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.Signal;

    public class ButtonSignals extends AbstractSignalSet
    {
		// signals
		public var mouseUp:Signal;
		public var mouseDown:Signal;
		public var mouseOver:Signal;
		public var mouseOut:Signal;

        public function ButtonSignals()
        {
        }
    }
}
