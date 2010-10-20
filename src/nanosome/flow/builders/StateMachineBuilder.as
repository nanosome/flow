// @license@
package nanosome.flow.builders 
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.AbstractSignal;
	import nanosome.flow.stateMachine.StateMachine;
	
	/**
	 * Suggestion is there'll be fairly small amount of StateMachines,
	 * so it makes sense to define them with separate classes, 
	 * to provide code hinting and typechecking at early stage.
	 * 
	 * @see SampleStateMachine
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilder 
	{
		private static const SIGNAL_ID_PREFIX:String 	= "si.";
		private static const STATE_ID_PREFIX:String 	= "st.";
		
		private var _stateMachine:StateMachine;
		private var _context:StateMachineBuilderContext;
		
		public var normal:State;
		
		public function StateMachineBuilder()
		{
			initiateStatesAndSignals();
			_stateMachine = new StateMachine(normal);
		}
		
		public function getContent():StateMachine
		{
			return _stateMachine;
		}
		
		private function initiateStatesAndSignals():void
		{
			var signalClassName:String = getQualifiedClassName(AbstractSignal);
			var stateClassName:String = getQualifiedClassName(State);
			var typeDesc:XML = describeType(this);
			
			var vars:XMLList = typeDesc.child("variable");
			
			var typeAttr:String;
			var nameAttr:String;
			
			for each (var item:XML in vars)
			{
				typeAttr = item.attribute("type");
				nameAttr = item.attribute("name");
				
				if (typeAttr == signalClassName)
					this[nameAttr] = new AbstractSignal(SIGNAL_ID_PREFIX + nameAttr);
				else if (typeAttr == stateClassName)
					this[nameAttr] = new State(STATE_ID_PREFIX + nameAttr);
			}
		}
		
		// DSL specific methods 
		
		public function from(state:State):StateMachineBuilder
		{
			_context = new StateMachineBuilderContext();
			_context.sourceState = state;
			return this;
		}
		
		public function by(signal:AbstractSignal):StateMachineBuilder
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

		public function back(signal:AbstractSignal):void
		{
			_context.targetState.addTransition(signal, _context.sourceState);
		}			
		
		private function checkExpression():void
		{
			if (	_context && _context.sourceState && _context.signal && _context.targetState &&
					!_context.sourceState.hasTransition(_context.signal.id)
				)
				_context.sourceState.addTransition(_context.signal, _context.targetState);
		}
	}
}
