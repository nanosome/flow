// @license@
package nanosome.flow.stateMachine
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

    import flashx.textLayout.tlf_internal;

    import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.signals.Signal;
	import nanosome.flow.stateMachine.StateMachine;
    import nanosome.flow.stateMachine.logic.Transition;

    /**
	 * Suggestion is there'll be fairly small amount of StateMachines,
	 * so it makes sense to define them with separate classes, 
	 * to provide code hinting and typechecking at early stage.
	 * 
	 * @see stateMachines.buttons.ButtonStateMachine
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilder 
	{
		private static const STATE_ID_PREFIX:String 	= "st.";
		
		private var _stateMachine:StateMachine;
		private var _context:StateMachineBuilderContext;
		
		public function StateMachineBuilder(defaultState:State)
		{
			initiateStates();
			_stateMachine = new StateMachine(defaultState);
		}
		
		public function getContent():StateMachine
		{
			return _stateMachine;
		}
		
		private function initiateStates():void
		{
			var stateClassName:String = getQualifiedClassName(State);
			var typeDesc:XML = describeType(this);
			
			var vars:XMLList = typeDesc.child("variable");
			
			var typeAttr:String;
			var nameAttr:String;
			
			for each (var item:XML in vars)
			{
				typeAttr = item.attribute("type");
				nameAttr = item.attribute("name");

                if (this[nameAttr] != null) // exit, if this member already exists
                    return;

				else if (typeAttr == stateClassName)
					this[nameAttr] = new State(STATE_ID_PREFIX + nameAttr);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  DSL specific methods
		//
		//--------------------------------------------------------------------------

		public function from(state:State):StateMachineBuilder
		{
			_context = new StateMachineBuilderContext();
			_context.sourceState = state;
			return this;
		}
		
		public function by(signal:Signal):StateMachineBuilder
		{
			_context.signal = signal;
			checkExpression();
			return this;
		}

		public function to(state:State):StateMachineBuilder
		{
			_context.targetState = state;
			checkExpression();
			return this;
		}

		public function back(signal:Signal):void
		{
			_context.targetState.addTransition(signal.id, _context.sourceState);
		}			
		
		private function checkExpression():void
		{
			if (	_context && _context.sourceState && _context.signal && _context.targetState &&
					!_context.sourceState.hasTransition(_context.signal.id)
				)
				_context.sourceState.addTransition(_context.signal.id, _context.targetState);
		}

        public function backIs(backTransition:Transition):StateMachineBuilder
        {
            return this;
        }

        public function _is(
                stateMachineBuilder:StateMachineBuilder,
                backStateMachineBuilder:StateMachineBuilder = null
                ):Transition
        {
            return null;
        }

	}
}
