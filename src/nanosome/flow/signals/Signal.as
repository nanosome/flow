// @license@
package nanosome.flow.signals
{
    import flash.events.Event;

    /**
     * This class is used together with <code>AbstractSignalSet</code> class.
     * <code>Signal</code> is notifying its parental <code>AbstractSignalSet</code> when its method
     * <code>Signal.fire</code> is invoked.
     *
     * @see nanosome.flow.signals.AbstractSignalSet
     * @author dimitri.fedorov
     */
    public class Signal
    {
        /**
         * @private
         * Holds unique ID for this signal.
         */
        private var _id:String;

       /**
        * @private
        * Holds parental <code>AbstractSignalSet</code> to be notified
        * when <code>Signal.fire</code> method is invoked.
        */
        private var _ownerSet:AbstractSignalSet;

        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        /**
         * Creates a new <code>Signal</code>. Constructor should be invoked automagically, see <code>AbstractSignalSet</code>.
         *
         * @param id ID for this signal
         * @param ownerSet Parental AbstractSignalSet to be notified when event will be fired
         * @see nanosome.flow.signals.AbstractSignalSet
         */
        public function Signal(id:String, ownerSet:AbstractSignalSet)
        {
            _id = id;
            _ownerSet = ownerSet;
        }

        /**
         * ID for the signal.
         *
         * @return ID for this signal
         */
        public function get id():String
        {
            return _id;
        }

        /**
         * Firing this signal, notifying parental <code>AbstractSignalSet</code>.
         * Can be used as event listener:
         * <listing version="3">
         *     myButton.addEventListener(MouseEvent.CLICK, mouseDownSignal.fire);
         * </listing>
         *
         * @see @see nanosome.flow.signals.AbstractSignalSet
         */
        public function fire(event:Event = null):void
        {
            _ownerSet.fireSignal(this);
        }

    }
}
