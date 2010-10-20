package tests 
{
	import nanosome.flow.stateMachine.logic.AbstractSignal;
	import net.antistatic.fluid.logic.BooleanCondition;
	import flexunit.framework.TestCase;

	/**
	 * @author dimitri.fedorov
	 */
	public class BooleanConditionTest extends TestCase
	{
		protected var _classScope:Boolean = true;
		
		public function testNegation():void 
		{
			var e:AbstractSignal = new AbstractSignal("hi");
			defineSignal(e, "hello");
			//var bc:BooleanCondition = new BooleanCondition(function():Boolean {return _classScope;});
			//var result:Boolean = bc.no.no.check();
		    assertEquals(e.id, "hi");
		}
		
		private function defineSignal(s:AbstractSignal, id:String):void
		{
			s = new AbstractSignal(id);
		}
		
	}
}
