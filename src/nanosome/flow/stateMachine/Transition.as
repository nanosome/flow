// @license@
package nanosome.flow.stateMachine
{
    /**
     * Transition class for <code>StateMachine</code>.
     * <code>Transition</code> consists of source and target states.
     *
     * @see StateMachine
     * @see State
     *
     * @author dimitri.fedorov
     */
    public class Transition
    {
        /**
         * @private
         * Holds source state.
         */
        private var _source:State;
        
        /**
         * @private
         * Holds destination state.
         */
        private var _target:State;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Transition() {}

        /**
         * Internal method for defining transition.
         * Delayed definition is required by DSL implementation logic.
         *
         * @param source Source state
         * @param target Target state
         */
        internal function define(source:State, target:State):void
        {
            _source = source;
            _target = target;
        }
           
        /**
         *  Source state for this transition
         */    
        public function get source():State
        {
            return _source;
        }           
           
        /**
         *  Target state for this transition
         */    
        public function get target():State
        {
            return _target;
        }

        /**
         * Check if <code>Transition</code> was defined.
         *
         * @returns True, if this transition was defined, false otherwise.
         */
        public function get isDefined():Boolean
        {
            return _source != null;
        }

        /**
         * Stringifier for Transition object
         */
        public function toString():String
        {
            return "[object Transition: (sourceState: " + _source + ", targetState: " + _target + ")]";
        }

    }
}