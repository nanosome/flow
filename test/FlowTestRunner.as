// @license@
package
{
    import org.as3commons.logging.setup.target.SOSTarget;
    import org.as3commons.logging.setup.SimpleTargetSetup;
    import org.as3commons.logging.LOGGER_FACTORY;
    import FlowEndToEndSuite;

    import org.flexunit.runner.FlexUnitCore;

    import flash.display.Sprite;

    import utils.AS3CommonsRunListener;

    [SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]

    /**
     * @author dimitri.fedorov
     */
    public class FlowTestRunner extends Sprite
    {
        private var _core:FlexUnitCore;
        
        public function FlowTestRunner()
        {
            // Instantiating the core.
            LOGGER_FACTORY.setup = new SimpleTargetSetup( new SOSTarget() );
            
            _core = new FlexUnitCore();
            _core.addListener(new AS3CommonsRunListener());
            _core.run( FlowEndToEndSuite );
        }
    }
}
