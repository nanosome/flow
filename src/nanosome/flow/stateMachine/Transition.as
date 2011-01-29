// @license@
package nanosome.flow.stateMachine
{
    /**
    *  State Transition for StateMachine
    *  
    *  @see StateMachine
    *  @see State
    *  
    *  @author dimitri.fedorov
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

        internal function define(source:State, target:State):void
        {
            _source = source;
            _target = target;
        }
           
        /**
         *  Returns source state for this transition
         */    
        public function get source():State
        {
            return _source;
        }           
           
        /**
         *  Returns target state for this transition
         */    
        public function get target():State
        {
            return _target;
        }

        public function get isDefined():Boolean
        {
            return _source != null;
        }

        public function toString():String
        {
            return "[object Transition: (sourceState: " + _source + ", targetState: " + _target + ")]";
        }

    }
}