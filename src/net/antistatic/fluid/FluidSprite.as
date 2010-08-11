////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008-2009 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid 
{
	
	// Importing Flash classes.
	import flash.events.Event;
	import flash.display.Sprite;
	
	
	/**
	 *  FluidSprite class. 
	 *  Generic sprite object with behaviours enabled.
	 *  
	 *  @author ai #212983
	 */
	public class FluidSprite extends Sprite 
	{
		// Messages constants  
		public static const CHANGE_STARTED:String 	= "FluidSprite_CHANGE_STARTED"; 
		public static const CHANGE_FINISHED:String 	= "FluidSprite_CHANGE_FINISHED";
	
		/**
		 * @private
		 */
		protected var behaviours:Array; /* of ButtonBehaviour */
		
			
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 */				
		public function FluidSprite() 
		{
			behaviours = new Array();
		}
	
		/**
		 * Event listener for Event.ENTER_FRAME event.
		 * Invokes mutations, deletes itself, if all mutations are completed.
		 * 
		 * @param event Event object.
		 */			
		protected function onEnterFrameHandler(event:Event):void 
		{
			if(!checkBehavioursStep()) // if no steps were made, remove ENTER_FRAME handler
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				dispatchEvent(new Event(FluidSprite.CHANGE_FINISHED));
			}
		}
	
		/**
		 * Adds behaviour to behaviours list
		 * 
		 * @param behaviour Behaviour to be added
		 */		
		public function addBehaviour(behaviour:IStepStateMachine, initiatingStateID:uint = 0):void
		{
			behaviour.initiate(initiatingStateID);
			behaviours.push(behaviour);
		}
		
		/**
		 * Checks every mutator to finish. Renews onEnterFrameHandler, if necessary.
		 */			
		public function checkOnEnterFrameHandlerRefresh():void
		{
	        if(checkBehavioursChange())
	        { 
				addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				dispatchEvent(new Event(FluidSprite.CHANGE_STARTED));
	        }		
		}
	
		/**
		 * Checks every behaviour to change.
		 * 
		 * @return true, if any behaviour has changed 
		 */			
		protected function checkBehavioursChange():Boolean
		{
			var somethingChanged:Boolean = false;
			
			for each (var behaviour:IStepStateMachine in behaviours)
				somethingChanged = behaviour.checkForStateChange() || somethingChanged;
			return somethingChanged;	
		}
		
		/**
		 * Checks every behaviour to finish.
		 * 
		 * @return false, if no steps were made
		 */			
		protected function checkBehavioursStep():Boolean
		{
			var stepWasMade:Boolean = false;
			for each (var behaviour:IStepStateMachine in behaviours)
				stepWasMade = behaviour.step() || stepWasMade;
			return stepWasMade;	
		}			
	
	}

}


