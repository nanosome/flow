// @license@
package nanosome.flow.builders 
{
	import nanosome.flow.stateMachine.logic.Signal;
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
