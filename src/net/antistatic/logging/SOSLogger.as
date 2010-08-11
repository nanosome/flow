package net.antistatic.logging
{
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
    import flash.events.Event;

    import flash.net.XMLSocket;
    import flash.utils.getQualifiedClassName;
    
    public class SOSLogger implements ILogger
    {     
        public static var clearOnConnect:Boolean = true;
        private static var socket:XMLSocket = new XMLSocket();
        private static var history:Array = new Array();
        private var _category:String;
        
        public var includeCategory:Boolean = true;
        public var includeLevel:Boolean = true;
        
        public var server:String = "localhost";
        
        private var fieldSeparator:String = ": ";
        
        public function SOSLogger( item:Object )
        {
            _category = (item is String) ? String(item) : getQualifiedClassName(item);
        }
        
        private function sendEvent ( level:int, category:String, message:String ) : void
        {
            var log:Object = {message: message};
            
            if (includeLevel)
                log["level"] = level;
            
            log["category"] = includeCategory ? category : "";
               
            if ( socket.connected )
            {
            	send(log);
            } 
            else 
            {
                if (!socket.hasEventListener("connect"))
                {
                    socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                    socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
                    socket.addEventListener(Event.CONNECT, onConnect);               		
                }

                socket.connect(server, 4444);

                history.push(log);
            }
        } 
        
        //--------------------------------------------------------------------------
        //
        //  Event handlers for Socket connection
        //
        //--------------------------------------------------------------------------

        private function onIOError(e:IOErrorEvent):void
        {
            // trace("XMLSocket IOError");
        }
         
        private function onSecurityError(e:SecurityErrorEvent):void
        {
            // trace("XMLSocket SecurityError");
        }
         
        private function onConnect(e:Event):void
        {
            for each(var log:Object in history)
            {
                send(log);
            }
        }
        
        private function send(o:Object):void
        {
            var msg:String = o["message"];
            var lines:Array = msg.split ("\n");
            var commandType:String= lines.length == 1 ? "showMessage" : "showFoldMessage";
            var key:String = getTypeByLogLevel(o["level"]);
            var xmlMessage:XML = <{commandType} key={key} />;
             
            if(lines.length > 1)
            {
                // set title with first line
                xmlMessage["title"] = lines[0];
                 
                // remove title from message
                xmlMessage["message"] = msg.substr(msg.indexOf("\n") + 1, msg.length);
                 
                if (o["category"] == null)
                    xmlMessage["category"] = o["category"];                 
            }
            else
            {
                var prefix:String = (o["category"] != null) ? (o["category"] + fieldSeparator) : "";
                xmlMessage.appendChild(prefix + msg);
            }
            socket.send('!SOS'+xmlMessage.toXMLString()+'\n');
        }
        
        private function getTypeByLogLevel(level:int):String
        {
            switch(level)
            {
                case LogEventLevel.DEBUG :
                     return "DEBUG";
                case LogEventLevel.INFO :
                     return "INFO";
                case LogEventLevel.WARN :
                     return "WARN";
                case LogEventLevel.ERROR :
                     return "ERROR";
                case LogEventLevel.FATAL :
                     return "FATAL";
                default:
                    return "INFO";
            }
        }                      
        
        public function debug(message:String, ... rest:Array):void
        {
            sendEvent( LogEventLevel.DEBUG, _category, message );
        }
        
        public function info(message:String, ... rest:Array):void
        {
            sendEvent( LogEventLevel.INFO, _category, message );
        }
        
        public function warn(message:String, ... rest:Array):void
        {
            sendEvent( LogEventLevel.WARN, _category, message );
        }
        
        public function error(message:String, ... rest:Array):void
        {
            sendEvent( LogEventLevel.ERROR, _category, message );
        }
        public function fatal(message:String, ... rest:Array):void
        {
            sendEvent( LogEventLevel.FATAL, _category, message );
        }
        
        public function log(level:int, message:String, ... rest:Array):void
        {
            sendEvent( level, _category, message );
        }
        
        public function get category():String
        {
            return _category.toString();
        }
    }
}