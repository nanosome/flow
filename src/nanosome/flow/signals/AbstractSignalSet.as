// @license@
package nanosome.flow.signals
{
    import flash.events.EventDispatcher;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    /**
     * This class is used as a builders, like other builders in Flow.
     * And, like other builders, it is supposed to be overriden and its using
     * implicit instantiation:
     *
     * <listing version="3">
     * package signals
     * {
     *     import nanosome.flow.signals.AbstractSignalSet;
     *     import nanosome.flow.signals.Signal;
     *
     *     public class TestSignalsSet extends AbstractSignalSet
     *     {
     *         public var signalA:Signal;
     *         public var signalB:Signal;
     *     }
     * }
     * </listing>
     *
     * @author df
     */
    public class AbstractSignalSet extends EventDispatcher
    {
        public static const SIGNAL_ID_PREFIX:String = "signal.";

        /**
         * This constructor shouldn't be overriden and even used in any way. See usage example.
         */
        public function AbstractSignalSet()
        {
            initiateSignals();
        }

        /**
         * This method runs through public properties of the class and auto-instantiates
         * those of Signal type.
         */
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

                if (this[nameAttr] != null)
                    continue;  // check another name, if this property with this name is already instantiated
                else if (typeAttr == stateClassName)
                    this[nameAttr] = new Signal(SIGNAL_ID_PREFIX + nameAttr, this);
            }
        }

        /**
         * This method is invoked by one of auto-instantiated children (<code>Signal</code> class)
         * to notify <code>AbstracSignalSet</code>.
         * @param signal
         */
        internal function fireSignal(signal:Signal):void
        {
            dispatchEvent(new SignalEvent(signal.id));
        }
    }
}
