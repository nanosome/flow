package net.antistatic.logging
{
    public class LogFactory
    {
        /**
         * @param category the source of the logs
         * the Logger can be constructed with a reference (this) or a String
         * 
         */
        public static function getLogger( category:Object ) : ILogger
        {
            return new SOSLogger( category );
        }
    }
}