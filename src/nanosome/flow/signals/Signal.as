// @license@
package nanosome.flow.signals
{
    import flash.events.Event;

    /**
     * <code>Signal</code> is supposed to be used with <code>AbstractSignalSet</code> class.
     *
     * @see nanosome.flow.signals.AbstractSignalSet
     * @author df
     */
    public class Signal
    {
        private var _id:String;
        private var _ownerSet:AbstractSignalSet;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * Creates a new <code>Signal</code>. Constructor should be invoked automatically, see <code>AbstractSignalSet</code>.
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
