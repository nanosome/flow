// @license@
package 
{
	import nanosome.flow.stateMachine.StateMachineController;

	/**
	 * @author dimitri.fedorov
	 */
	public class SampleVSMBuilder 
	{
		public function SampleVSMBuilder()
		{
			var sm:SampleStateMachine = new SampleStateMachine();
			var viz:StateMachineController = new StateMachineController(sm.getContent());
			
			// -- transitions 
			
			// problem here is we may want to group transitions by easing,
			// duration or both. most obvious way to let people do so: 
			viz.set(
				sm.fromNormalToOvered, sm.fromOveredToNormal
			).easing(Linear.easeInOut).duration(150);
			
	
			viz.set(sm.fromOveredToPressed, sm.fromPressedToPressedOutside).easing(Linear.easeIn).duration(75);
			viz.set(sm.fromPressedToOvered, sm.fromPressedOutsideToPressed).easing(Linear.easeOut).duration(50);
			viz.set(sm.fromPressedToNormal).easing(Linear.easeOut).duration(100);
			
			// you can override later some parts:
			viz.set(sm.fromOveredToPressed, sm.fromPressedToOvered).duration(120);
			
			// -- states
			
			// -- events / bindings 
		}
	}
}
