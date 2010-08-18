package net.antistatic.processes 
{
import flash.events.Event;
import flash.display.Sprite;

import nanosome.flow.stateMachine.logic.State;	
import nanosome.flow.stateMachine.StateMachine;

/**
 * @author User
 */
public class Process extends StateMachine
{
	public static const STOPPED_STATE:String 	= "Process_STOPPED_STATE";
	public static const RUNNING_STATE:String 	= "Process_RUNNING_STATE";
	public static const FINISHED_STATE:String 	= "Process_FINISHED_STATE";
	
	public static const RUNNING_ACTION:String 		= "Process_RUNNING_ACTION";
	public static const FINISHING_ACTION:String 	= "Process_FINISHING_ACTION";
	
	// errors:
	// start failed errors

    private var frameTracker:Sprite;
	private var frameTrackingIsSet:Boolean;

	
	protected var stoppedState:State;
	protected var runningState:State;
	protected var finishedState:State;
	
	public function Process():void
	{
		frameTracker = new Sprite();
		frameTrackingIsSet = false;
				
		stoppedState = new State(STOPPED_STATE);
		runningState = new State(RUNNING_STATE);
		finishedState = new State(FINISHED_STATE);

		this.addState(stoppedState);
		this.addState(runningState);
		this.addState(finishedState);

		this.addTransition(stoppedState, null, runningState, RUNNING_ACTION);
		this.addTransition(runningState, null, finishedState, FINISHING_ACTION);
		
		this.setState(stoppedState);
		
		setAsStrict();
		addEventListener(StateMachine.ACTION_CHANGED, onChanged);		
	}
	
	
	public function start():void
	{
		checkWithState(runningState);
		/*
		try
		{
			checkWithState(runningState);
		}
		catch(err:Error)
		{
			trace("************** CANT START PROCESS!!! ");
		}
		 * 
		 */
	}

	public function complete():void
	{
		checkWithState(finishedState);
		/*
		try
		{
			checkWithState(finishedState);
		}
		catch(err:Error)
		{
			trace("************** CANT COMPLETE PROCESS!!! / "+getCurrentState());
		}
		*/
	}
	
	private function onChanged(event:Event):void
	{
		var action:String = getCurrentAction();
		
		switch(action)
		{
			case RUNNING_ACTION:
				dispatchEvent(new ProcessEvent(ProcessEvent.STARTED, this));
			break;
			
			case FINISHING_ACTION:
				dispatchEvent(new ProcessEvent(ProcessEvent.FINISHED, this));
			break;
		}
	}
	
	//--------------------------------------
	//  Frame tracking
	//--------------------------------------

	/**
	 * @private
	 * If frame tracking is off, turns it on.
	 * Otherwise, does nothing.
	 */
	protected function addFrameTracking():void
	{
		if(!frameTrackingIsSet)
		{
			frameTrackingIsSet = true;
			frameTracker.addEventListener(Event.ENTER_FRAME, onEnterFrameEvent);
		}
	}
	
	/**
	 * @private
	 * If frame tracking is on, turns it off.
	 * Otherwise, does nothing.
	 */
	protected function removeFrameTracking():void
	{
		if(frameTrackingIsSet)
		{
			frameTrackingIsSet = false;
			frameTracker.removeEventListener(Event.ENTER_FRAME, onEnterFrameEvent);
		}
	}	

	protected function onEnterFrameEvent(event:Event):void
	{
	}
	
}

}
