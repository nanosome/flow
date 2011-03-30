package utils
{
    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LOGGER_FACTORY;
    import org.as3commons.logging.getLogger;

    import org.as3commons.logging.setup.SimpleTargetSetup;
    import org.as3commons.logging.setup.target.SOSTarget;
    import org.flexunit.reporting.FailureFormatter;
    import org.flexunit.runner.IDescription;
    import org.flexunit.runner.Result;
    import org.flexunit.runner.notification.Failure;
    import org.flexunit.runner.notification.RunListener;
    
    /**
     * A <code>SOSRunListener</code> will output the events encountered during the course of a test run to the SOS logger.
     * 
     * @author dimitri.fedorov
     */
    public class AS3CommonsRunListener extends RunListener 
    {
        private static var _logger: ILogger = getLogger( AS3CommonsRunListener );
        
        /**
         * Constructor.
         */
        public function AS3CommonsRunListener() {
            super();
        }

        /**
         * @inheritDoc
         */
        override public function testRunFinished(result:Result):void 
        {
            printHeader(result.runTime);
            printFailures(result);
            printFooter(result);
        }

        /**
         * @inheritDoc
         */
        override public function testStarted(description:IDescription):void 
        {
            _logger.debug(description.displayName + " .");
        }

        /**
         * @inheritDoc
         */
        override public function testFailure(failure:Failure):void 
        {
            //Determine if the exception in the failure is considered an error
            if (FailureFormatter.isError(failure.exception)) 
                _logger.error( failure.description.displayName + " E" );
            else
                _logger.warn( failure.description.displayName + " F" );
        }

        /**
         * @inheritDoc
         */
        override public function testIgnored(description:IDescription ):void 
        {
            _logger.debug(description.displayName + " I");
        }

        /**
         * Outputs timing information for the running test
         *
         * @param description
         * @param runTime
         *
         */
        public function testTimed(description:IDescription, runTime:Number):void 
        {
            _logger.debug(description.displayName + " took " + runTime + " ms ");
        }

        /*
         * Internal methods
         */

        /**
         * Traces a header that provides the total run time
         *
         * @param runTime The total run time of all tests in milliseconds
         */
        protected function printHeader(runTime:Number):void 
        {
            _logger.debug("Time: " + elapsedTimeAsString(runTime));
            //trace( elapsedTimeAsString(runTime) );
        }

        /**
         * Traces all failures that were received in the result
         *
         * @param result The result that contains potential failures
         */
        protected function printFailures(result:Result):void 
        {
            var i:int;
            var k:int;
            var failures:Array = result.failures;
            // Determine if there are any failures to print
            if (failures.length == 0)
                return;

            _logger.warn("There was " + failures.length + " failure" +(failures.length == 1 ? ":" : "s:"));

            //Print each failure
            for (i = 0, k = failures.length; i < k; i++ ) 
            {
                printFailure(failures[i], String(i + 1));
            }
        }

        /**
         * Traces a provided failure with a certain prefix
         *
         * @param failure The provided failure
         * @param prefix A String prefix for the failure
         */
        protected function printFailure(failure:Failure, prefix:String):void 
        {
            _logger.warn(prefix + " " + failure.testHeader + " " + failure.stackTrace);
        }

        /**
         * Traces a footer for the provided result
         *
         * @param result The result that contains the total run count
         */
        protected function printFooter(result:Result):void 
        {
            if (result.successful) 
                _logger.debug( "OK (" + result.runCount + " test" + (result.runCount == 1 ? "" : "s") + ")" );
            else
                _logger.error( "FAILURES!!! Tests run: " + result.runCount + ", " + result.failureCount + " Failures:" );
        }

        /**
         * Returns the formatted string of the elapsed time. Duplicated from
         * BaseTestRunner. Fix it.
         */
        protected function elapsedTimeAsString(runTime:Number):String 
        {
            return String(runTime / 1000);
        }
    }
}