// @license@
package nanosome.flow.signals
{
    import flash.events.EventDispatcher;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    /**
     * This class is supposed to be used as a builder.
     * And, like other builders in Flow, it's supposed to be using
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
     * @see wiki:ImplicitInstantiationInBuilders
     *
     * @author dimitri.fedorov
     */
    public class AbstractSignalSet extends EventDispatcher
    {
        public static const SIGNAL_ID_PREFIX:String = "signal.";

        /**
         * This constructor shouldn't be used or referenced in any way.
         * See usage example.
         */
        public function AbstractSignalSet()
        {
            initiateSignals();
        }

        /**
         * This method runs through public properties of the class
         * and auto-instantiates those of Signal type.
         */
        private function initiateSignals():void
        {
            var stateClassName:String = getQualifiedClassName(Signal);
            var typeDesc:XML = describeType(this);
            var vars:XMLList = typeDesc.child("variable");
            var nameAttr:String;

            for each (var item:XML in vars)
            {
                nameAttr = item.attribute("name");

                if (this[nameAttr] == null && item.attribute("type") == stateClassName)
                    this[nameAttr] = new Signal(SIGNAL_ID_PREFIX + nameAttr, this);
            }
        }

        /**
         * This method is invoked by one of auto-instantiated children (<code>Signal</code> class)
         * to notify <code>AbstractSignalSet</code> of being fired.
         * @param signal
         */
        internal function fireSignal(signal:Signal):void
        {
            dispatchEvent(new SignalEvent(signal.id));
        }
    }
}
