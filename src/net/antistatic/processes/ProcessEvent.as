package net.antistatic.processes 
{
import flash.events.Event;

/**
 * @author User
 */
public class ProcessEvent extends Event
{
	public static const STARTED:String 		= "Process_STARTED";
	public static const FINISHED:String 	= "Process_FINISHED";
	public static const ABORTED:String 		= "Process_ABORTED";
	public static const FAILED:String 		= "Process_FAILED";
	public static const PROGRESS:String 	= "Process_PROGRESS";
	
	public var body:Process;
	
	public function ProcessEvent(name:String, body:Process):void
	{
		this.body = body;
		super(name);
	}
	
	
}

}
