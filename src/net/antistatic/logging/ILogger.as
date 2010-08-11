package net.antistatic.logging 
{
  public interface ILogger
  {
    function get category():String;
    
    function debug(message:String, ...args:*):void;
    
    function error(message:String, ...args:*):void;
    
    function fatal(message:String, ...args:*):void;
    
    function info(message:String, ...args:*):void;
    
    function log(level:int, message:String, ...args:*):void;
    
    function warn(message:String, ...args:*):void;
  }
}