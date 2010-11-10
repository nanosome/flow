// @license@
package nanosome.flow.stateMachine
{
	import nanosome.flow.signals.Signal;
	import nanosome.flow.stateMachine.logic.State;

	/**
	 * @author dimitri.fedorov
	 */
	public class StateMachineBuilderContext 
	{
		public var sourceState:State;
		public var signal:Signal;
		public var targetState:State;		
	}
}
