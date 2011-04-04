// @license@
package nanosome.flow.visualizing
{
    /**
     * This is the base class for defining transition behavior.
     * Transition between two states of complex element is defined by time.
     * Unlike easing start and end values, which are bound to certain states,
     * TimedEasing is bound to transition itself only.
     */
    public class TimedEasing
    {
        /**
         *  @private
         *  Holds function for easing.
         */
        internal var _easing:Function;

        /**
         *  @private
         *  Holds duration value in whatever units
         */
        internal var _duration:Number;

        public function TimedEasing(easing:Function, duration:Number)
        {
            _easing = easing;
            _duration = duration;
        }

        public function get duration():Number
        {
            return _duration;
        }

        public function get easing():Function
        {
            return _easing;
        }
    }
}
