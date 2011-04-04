// @license@
package nanosome.flow.signals
{
    import flash.events.Event;

    /**
     * Custom event used by <code>AbstractSignalSet</code> for notifying outer systems of firing events.
     *
     * @author df
     */
    public class SignalEvent extends Event
    {
        public static const SIGNAL_FIRED:String = "signalFired";

        /**
         * ID of the Signal was fired
         */
        private var _signalID:String;

        /**
         * Creates a new <code>SignalEvent</code>
         *
         * @param signalID ID of the <code>Signal</code> to be notified of;
         * @param signal
         */
        public function SignalEvent(signalID:String)
        {
            super(SIGNAL_FIRED);
            _signalID = signalID;
        }

        /**
         * Signal ID
         */
        public function get signalID():String
        {
            return _signalID;
        }
    }
}
