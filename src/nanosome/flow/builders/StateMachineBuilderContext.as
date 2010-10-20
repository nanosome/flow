// @license@
package nanosome.flow.builders 
{
	import nanosome.flow.stateMachine.logic.AbstractSignal;
	import nanosome.flow.stateMachine.logic.State;

	/**
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilderContext 
	{
		public var sourceState:State;
		public var signal:AbstractSignal;
		public var targetState:State;		
	}
}
