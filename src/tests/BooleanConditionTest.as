package tests 
{
	import nanosome.flow.signals.Signal;
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
			var e:Signal = new Signal("hi");
			defineSignal(e, "hello");
			//var bc:BooleanCondition = new BooleanCondition(function():Boolean {return _classScope;});
			//var result:Boolean = bc.no.no.check();
		    assertEquals(e.id, "hi");
		}
		
		private function defineSignal(s:Signal, id:String):void
		{
			s = new Signal(id);
		}
		
	}
}
