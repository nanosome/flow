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
         * Holds source <code>State</code> .
         */
        private var _source:State;
        
        /**
         * @private
         * Holds destination <code>State</code> .
         */
        private var _target:State;


        //--------------------------------------------------------------------------
        //
        //  CONSTRUCTOR
        //
        //--------------------------------------------------------------------------

        public function Transition() {}

        /**
         * Internal method for defining <code>Transition</code>.
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
         *  Source <code>State</code> for this transition.
         */    
        public function get source():State
        {
            return _source;
        }           
           
        /**
         *  Target <code>State</code> for this transition.
         */    
        public function get target():State
        {
            return _target;
        }

        /**
         * Check if <code>Transition</code> was defined.
         *
         * @returns <code>true</code>, if this transition was defined properly, <code>false</code> otherwise.
         */
        public function get isDefined():Boolean
        {
            return _source != null;
        }

        /**
         * Stringifier for <code>Transition<code> object.
         *
         * @returns String representation of this <code>Transition<code>.
         */
        public function toString():String
        {
            return "[object Transition: (sourceState: " + _source + ", targetState: " + _target + ")]";
        }

    }
}