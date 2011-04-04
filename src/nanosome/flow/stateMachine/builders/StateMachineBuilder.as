// @license@
package nanosome.flow.stateMachine.builders
{
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.utils.ClassUtils;

    /**
     * <code>StateMachineBuilder</code> is used for state machines configuration and creation.
     * Once created, state machine can be reused with <code>StateMachineProcessor</code>.
     * Using separate class for state machine configuration provides developer with code hinting
     * and type checking at pre-compile stage.
     *
     * State machine configuration is done by extending <code>StateMachineBuilder</code> class:
     * <listing version="3">
     * package stateMachine.builder
     * {
     *     import nanosome.flow.stateMachine.StateMachine;
     *     import nanosome.flow.stateMachine.builders.StateMachineBuilder;
     *     import nanosome.flow.stateMachine.State;
     *     import nanosome.flow.stateMachine.Transition;
     *
     *     import misc.ButtonSignals;
     *
     *     public class TestStateMachineBuilder extends StateMachineBuilder
     *     {
     *          // states
     *          public var normal:State;
     *          public var overed:State;
     *          public var pressed:State;
     *          public var pressedOutside:State;
     *
     *          // transitions
     *          public var fromNormalToOvered:Transition;
     *          public var fromOveredToNormal:Transition;
     *          public var fromOveredToPressed:Transition;
     *          public var fromPressedToOvered:Transition;
     *          public var fromPressedToPressedOutside:Transition;
     *          public var fromPressedOutsideToPressed:Transition;
     *          public var fromPressedOutsideToNormal:Transition;
     *
     *          public function getNewSignalsSet():ButtonSignals
     *          {
     *              return new ButtonSignals();
     *          }
     *
     *          override protected function configureStateMachine():void
     *          {
     *              var signals:ButtonSignals = getNewSignalsSet();
     *
     *              initialState = normal;
     *
     *              fromNormalToOvered = _.
     *                  from(normal).to(overed).by(signals.mouseOver).
     *                  back(fromOveredToNormal, signals.mouseOut)._;
     *
     *              fromOveredToPressed = _.
     *                  from(overed).to(pressed).by(signals.mouseDown).
     *                  back(fromPressedToOvered, signals.mouseUp)._;
     *
     *              fromPressedToPressedOutside = _.
     *                  from(pressed).to(pressedOutside).by(signals.mouseOut).
     *                  back(fromPressedOutsideToPressed, signals.mouseOver)._;
     *
     *
     *              fromPressedOutsideToNormal = _.from(pressedOutside).to(normal).by(signals.mouseUp)._;
     *          }
     *     }
     * }
     * </listing>
     *
     * Every StateMachineBuilder should have <code>getNewSignalsSet()</code> method, returning used set of signals.
     * State machine is declared basing on its transitions, internal DSL constructs are used:
     * <ul>
     * <li><code>_.</code> - starting transition declaration</li>
     * <li><code>from(state)</code> - specifying initial state</li>
     * <li><code>to(state)</code> - specifying target state</li>
     * <li><code>by(signal)</code> - specifying signal responsible for switching from initial to target state</li>
     * <li><code>back(transition, signal)</code> - specifying transition for switching back and respective signal</li>
     * <li><code>._</code> - ending transition declaration</li>
     * </ul>
     * Please note, States and Transitions should be declared as <code>public</code> in order to be seen by reflection routines.
     *
     * @author dimitri.fedorov
     */
    public class StateMachineBuilder 
    {
        //----------------------------------
        //  Static constants and vars
        //----------------------------------

        private static const STATE_ID_PREFIX:String     = "st.";

        //----------------------------------
        //  Regular class properties
        //----------------------------------

        private var _stateMachine:StateMachine;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * Constructor for classes extending <code>StateMachineBuilder</code> is invoked implicitly
         * and shouldn't be invoked directly or overriden until necessary.
         */
        public function StateMachineBuilder()
        {
            initiateStatesAndTransitions();
            configureStateMachine();
            checkTransitions();
            validateStateMachine();
        }

        /**
         * This setter should be invoked in <code>configureStateMachine</code> method to specify
         * initial state for this state machine.
         * 
         * @param state Initial state for this state machine.
         */
        protected function set initialState(state:State):void
        {
            _stateMachine = new StateMachine(state);
        }

        /**
         * Returns configured state machine
         * @return configured state machine
         */
        public function getStateMachine():StateMachine
        {
            return _stateMachine;
        }

        /**
         *  This method should be overriden and contain state machine configuration.
         */
        protected function configureStateMachine():void
        {
            throw new Error("This method should be overriden.");
        }

        //--------------------------------------------------------------------------
        //
        //  utility methods
        //
        //--------------------------------------------------------------------------

        /**
         * We need all states and transitions before constructing DSL expressions.
         * Unlike states, transitions will be instantiated, but not defined.
         */
        private function initiateStatesAndTransitions():void
        {
            var names:Vector.<String> = ClassUtils.getVariablesOfType(this, State);
            var name:String;

            for each (name in names)
            {
                this[name] = new State(STATE_ID_PREFIX + name);
            }

            names = ClassUtils.getVariablesOfType(this, Transition);
            for each (name in names)
            {
                this[name] = new Transition();
            }
        }

        /**
         * Performs check if every transition was defined and is not null.
         * If there's null transitions, throws an error.
         */
        private function checkTransitions():void
        {
            var transitionNames:Vector.<String> = ClassUtils.getVariablesOfType(this, Transition);
            var notDefinedTransitions:Array = [];
            for each (var transitionName:String in transitionNames)
            {
                if (!Transition(this[transitionName]).isDefined)
                    notDefinedTransitions.push("'" + transitionName + "'");
            }

            if (notDefinedTransitions.length > 0)
                throw new Error(
                        "Following transitions should be defined: " +
                        notDefinedTransitions.join(", ") +
                        "."
                );
        }

        /**
         * Performs state machine validation by collecting its states and transitions
         * and comparing them with states and transitions contained by this current builders.
         */
        private function validateStateMachine():void
        {

            var name:String;
            var missingStates:Vector.<State> = new Vector.<State>();
            var missingTransitions:Vector.<Transition> = new Vector.<Transition>();

            var smStates:Vector.<State> = getStateMachine().states;
            var smTransitions:Vector.<Transition> = getStateMachine().transitions;

            var names:Vector.<String> = ClassUtils.getVariablesOfType(this, State);
            for each (name in names)
            {
                if (smStates.indexOf(this[name]) < 0)
                    missingStates.push(this[name]);
            }

            names = ClassUtils.getVariablesOfType(this, Transition);
            for each (name in names)
            {
                if (smTransitions.indexOf(this[name]) < 0)
                    missingTransitions.push(this[name]);
            }

            if (missingStates.length > 0)
                throw new Error("State Machine has been built with errors, has missing States: " + missingStates);

            if (missingTransitions.length > 0)
                throw new Error("State Machine has been built with errors, has missing Transitions: " + missingTransitions);
        }
        
        //--------------------------------------------------------------------------
        //
        //  DSL specific methods
        //
        //-------------------------------------------------------------------------

        /**
         * DSL-specific method, used for building transition expression.
         */
        final protected function get _():TransitionBuilder
        {
            return new TransitionBuilder(getStateMachine());
        }
        
    }
}
