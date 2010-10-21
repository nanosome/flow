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
			viz.define(
				sm.fromNormalToOvered, sm.fromOveredToNormal
			).easing(Linear.easeInOut).duration(150);
			
	
			// it is possible to define transition partly...
			viz.define(sm.fromOveredToPressed, sm.fromPressedToOvered).duration(75);
			viz.define(sm.fromPressedToPressedOutside, sm.fromPressedOutsideToPressed).duration(50);
			
			// and define other part later in the code 
			viz.define(sm.fromPressedToPressedOutside, sm.fromOveredToPressed).easing(Elastic.easeIn);
			viz.define(sm.fromPressedOutsideToPressed, sm.fromPressedToOvered).easing(Elastic.easeOut);
			
			viz.define(sm.fromPressedOutsideToNormal).easing(Linear.easeOut).duration(100);
			
			// -- states
			
			// -- events / bindings 
		}
		
		
	}
}
