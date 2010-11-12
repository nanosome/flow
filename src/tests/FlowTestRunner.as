// @license@
package tests
{
    import org.flexunit.listeners.CIListener;

    import org.flexunit.listeners.UIListener;

    import tests.FlowEndToEndSuite;

	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

    import tests.utils.SOSRunListener;

    [SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]

	/**
	 * @author dimitri.fedorov
	 */
	public class FlowTestRunner extends Sprite
	{
		private var _core:FlexUnitCore;
		private var _tests : Array;
		
		public function FlowTestRunner()
		{
			// Instantiating the core.
			_core = new FlexUnitCore();
            _core.addListener(new SOSRunListener());
            _core.run( FlowEndToEndSuite );
	
		}
	}
}
