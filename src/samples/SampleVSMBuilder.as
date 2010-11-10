// @license@
package sample
{
	import nanosome.flow.stateMachine.StateMachineController;
    import mx.effects.easing.Linear;
    import mx.effects.easing.Elastic;

    import nanosome.flow.stateMachine.logic.Transition;

    import sample.stateMachines.ButtonStateMachine;

    /**
	 * @author dimitri.fedorov
	 */
	public class SampleVSMBuilder 
	{
		public function SampleVSMBuilder()
		{
			var sm:ButtonStateMachine = new ButtonStateMachine();
			var viz:StateMachineController = new StateMachineController(sm.getContent());
			
			// -- transitions 
			
			// problem here is we may want to group transitions by easing,
			// duration or both. most obvious way to let people do so: 
			transition(sm.fromNormalToOvered).easing(Linear.easeInOut).duration(150);
			
            transition(sm.fromOveredToNormal).easing(Linear.easeInOut).duration(150);

			// it is possible to define transition partly...
			transition(sm.fromPressedToPressedOutside).and(sm.fromPressedOutsideToPressed).
                duration(50);

            transition(sm.fromOveredToPressed).and(sm.fromPressedToOvered).duration(75);

			// and define other part later in the code 
			transition(sm.fromPressedToPressedOutside).and(sm.fromOveredToPressed).easing(Elastic.easeIn);
			transition(sm.fromPressedOutsideToPressed).and(sm.fromPressedToOvered).easing(Elastic.easeOut);
			
			transition(sm.fromPressedOutsideToNormal).easing(Linear.easeOut).duration(100);
			
			// -- states
            state()
			
			// -- events / bindings 
		}

        public function transition(target:Transition):TransitionBuilder
        {
        }

        public function transition(target:Transition):TransitionBuilder
        {
        }
		
	}
}
