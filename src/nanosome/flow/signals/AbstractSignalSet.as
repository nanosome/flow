package nanosome.flow.signals
{
    import flash.events.EventDispatcher;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    /**
     * There is some concerns regarding signals:
     * 1) circular referencing (passing to each signal its parent)
     * 2) Necessity to instantiate a set of signals for each state machine
     * processor may lead to excessive memory consuming.
     *
     * First issue seems to be minor one, as signals now are handled together
     * with their parent sets, and should be garbage collected properly even with flash
     * garbage collector.
     *
     * Second issue may be serious enough, although it require testing,
     * how much is used, how fast/slow it is, etc. For now, I'll leave
     * it as is for the sake of being short and already working, but its
     * the first candidate to review/rewrite, after flow is done and running.
     *
     * -df
     */
    public class AbstractSignalSet extends EventDispatcher
    {
        public static const SIGNAL_ID_PREFIX:String = "signal.";

        public function AbstractSignalSet()
        {
            initiateSignals();
        }

		private function initiateSignals():void
		{
			var stateClassName:String = getQualifiedClassName(Signal);
			var typeDesc:XML = describeType(this);

			var vars:XMLList = typeDesc.child("variable");

			var typeAttr:String;
			var nameAttr:String;

			for each (var item:XML in vars)
			{
				typeAttr = item.attribute("type");
				nameAttr = item.attribute("name");

                if (this[nameAttr] != null) // exit, if this member already exists
                    return;

				else if (typeAttr == stateClassName)
					this[nameAttr] = new Signal(SIGNAL_ID_PREFIX + nameAttr, this);
			}
		}

        public function fireSignal(signal:Signal):void
        {
            dispatchEvent(new SignalEvent(signal));
        }
    }

}
