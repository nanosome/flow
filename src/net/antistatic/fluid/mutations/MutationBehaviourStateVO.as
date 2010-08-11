////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.mutations 
{
	import net.antistatic.fluid.easing.EasingLine;	
	
	/**
	 *  Mutator class is a subclass of AbstractMutator.
	 *  When changing states, it mutates object properties with Mutation class and Easing functions.    
	 *  It also performs soft transition between Easing functions. 
	 *  
	 *  @see EasingLine
	 *  
	 *  @author ai #212983
	 */
	public class MutationBehaviourStateVO
	{
		/**
		 * @private
		 * Holds current position for switching states. 
		 */
		public var pos:Number;	
	
		/**
		 * @private
		 * Holds current easing. We have to provide continuous non-jumpy changing of this parameter as well. 
		 */
		public var easingLine:EasingLine;	
		
		/**
		 * @private
		 * Holds current value. We have to provide continuous non-jumpy changing of this parameter. 
		 */
		public var value:Number;	
			
		/**
		 * @private
		 * Holds value we're moving from. 
		 */
		public var from:Number;	
	
		/**
		 * @private
		 * Holds value we're moving to. 
		 */
		public var to:Number;	
	
			
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 */	
		public function MutationBehaviourStateVO(pos:Number, easingLine:EasingLine, value:Number, from:Number, to:Number)
		{
			this.pos = pos;
			this.easingLine = easingLine;
			this.value = value;
			this.from = from;
			this.to = to;
		}
			
	}

}
