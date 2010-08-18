// @license@
package 
{
	import utils.SOSRunListener;
	import tests.BooleanConditionTest;

	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]

	/**
	 * @author dimitri.fedorov
	 */
	public class FlowTest extends Sprite 
	{
		private var _core:FlexUnitCore;
		private var _tests : Array;
		
		public function FlowTest()
		{
			// Instantiating the core.
			_core = new FlexUnitCore();
            _core.addListener(new SOSRunListener());
            
            _tests = [
                    BooleanConditionTest
            ];
            
            _core.run( _tests );
	
		}
		/*FDT_IGNORE*/
		public function someTest():void
		{
			var sm:StateMachine = new StateMachine();
			
			sm.addState(new State("normal"));
			sm.addState(new State("overed"));
			sm.addState(new State("overedAndPressed"));
			sm.addState(new State("pressedOutside"));
			
			sm.addTwoWayTransition(sm.state("normal"), sm.state("overed")); // normalToOvered, overedToNormal
			sm.addTwoWayTransition(sm.state("overed"), sm.state("overedAndPressed")); // overedToOveredAndPressed, overedAndPressedToOvered
			sm.addTransition(sm.state("overedAndPressed"), sm.state("pressedOutside")); // overedAndPressedToPressedOutside
			sm.addTransition(sm.state("pressedOutside"), sm.state("normal")); // pressedOutsideToNormal
			
			var vsm:VisualStateMachine = new VisualStateMachine(sm);
			vsm.setTransitionSignalFor(sm.transition("normalToOvered"), function():Boolean {return true;});
			
			vsm.addVisualizer(new PlainStateMachineVisualizer(iconSprite, "alpha"));
			
		} 
		
		public interface IStateMachineVisualizer
		
		/*FDT_IGNORE*/
	}
}
