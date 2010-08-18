package tests 
{
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
			var bc:BooleanCondition = new BooleanCondition(function():Boolean {return _classScope;});
			var result:Boolean = bc.no.no.check();
		    assertEquals(result, true);
		}
		
	}
}
