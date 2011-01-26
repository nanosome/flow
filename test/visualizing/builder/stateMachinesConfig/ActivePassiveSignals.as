package visualizing.builder.stateMachinesConfig
{
    import flash.events.EventDispatcher;

    import nanosome.flow.signals.AbstractSignalSet;
    import nanosome.flow.signals.Signal;

    public class ActivePassiveSignals extends AbstractSignalSet
    {
		public var setActive:Signal;
		public var setPassive:Signal;
    }
}
