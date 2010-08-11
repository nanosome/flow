////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.ui 
{
	import flash.display.Sprite;
		
	/**
	 * @private
	 * Importing Flash classes.
	 */	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	import net.antistatic.fluid.FluidSprite;
	
	
	/**
	 *  AbstractButton class. 
	 *  Beta version, this class is about to change.
	 *  
	 *  @author ai #212983
	 */
	public class AbstractButton extends FluidSprite 
	{
		/**
		 * @private
		 * Actually this variable is never used, declaring it to avoid Flash IDE compiling error.
		 */		
		public var _avoiding_Flash_IDE_error_warning:MovieClip;
	
		/**
		 * @private
		 */
		protected var overed:Boolean = false;
		
		/**
		 * @private
		 */
		protected var pressed:Boolean = false;
		
		/**
		 * @private
		 */
		protected var _hitLayer:Sprite;		
			
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 */				
		public function AbstractButton() 
		{
			super();
		}
	
		/**
		 * Initiates AbstractButton, adds objects to mutation pool and builds 
		 * <code>SimpleButton</code> instance for mouse detection. 
		 * 
		 * @param layers Objects to be included into mutation pool.
		 * @param hitLayer Object to be used as hit detection area for the button. 
		 */	
		public function init(hitLayer:Sprite):void
		{
			_hitLayer = hitLayer; 
	
	    	_hitLayer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	    	_hitLayer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);		
	    	_hitLayer.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
	    	_hitLayer.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		/**
		 * Returns 'overed' state for the button.
		 * 
		 * @return <code>true</code>, if mouse is over the button, <code>false</code>, if not. 
		 */		
		public function isOvered():Boolean
		{
			return overed;
		}
		
		/**
		 * Returns 'pressed' state for the button.
		 * 
		 * @return <code>true</code>, if mouse is pressed over the button, <code>false</code>, if not. 
		 */		
		public function isPressed():Boolean
		{
			return pressed;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Mouse Listeners
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event listener for mouseOver event.
		 * 
		 * @param event Event object.
		 */		 
		protected function mouseOverHandler(event:MouseEvent):void 
		{
	       overed = true;
	       dispatchEvent(new Event("onRollover"));       
	       checkOnEnterFrameHandlerRefresh();
	    }
	
		/**
		 * Event listener for mouseOut event.
		 * 
		 * @param event Event object.
		 */		 
		protected function mouseOutHandler(event:MouseEvent):void 
		{
	       overed = false;
	       dispatchEvent(new Event("onRollout"));         
	       checkOnEnterFrameHandlerRefresh();
	 
	    }
	
		/**
		 * Event listener for mouseDown event.
		 * 
		 * @param event Event object.
		 */		 
		protected function mouseDownHandler(event:MouseEvent):void 
		{
	        pressed = true;
			// We have to check for global mouseUp to catch releaseOutside event
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatchEvent(new Event("onPress")); 
	        checkOnEnterFrameHandlerRefresh();        
	    }
	
		/**
		 * Event listener for mouseUp event.
		 * 
		 * @param event Event object.
		 */		 
		protected function mouseUpHandler(event:MouseEvent):void 
		{
	        pressed = false;
	        // do NOT forget to remove listener for Garbage Collector!
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
	        dispatchEvent(new Event("onRelease"));
	        checkOnEnterFrameHandlerRefresh();         	 	        
	    }
	
	}

}


