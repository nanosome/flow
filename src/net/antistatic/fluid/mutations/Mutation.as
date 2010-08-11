////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.mutations 
{
	
	/**
	 *  Mutation class is used as data structure for different kinds of tweening, 
	 *  it holds range for mutation and mutation name.
	 *  <p>It also serves for casting mutation on objects.</p>
	 *  
	 *  @author ai #212983
	 */
	public class Mutation 
	{
	
		/**
		 *  Applies mutation to the given object.
		 *  Mutating objects like this is no Good Thing (not safe), 
		 *  but it's okay for lightweight lib like this
		 *  
		 *  @param obj Object to be mutated. 
		 *  @param val Value to apply for mutation (NOTE: No inrange checking!).  
		 */		
		public function applyValue(obj:Object, val:Number):void
		{
	
		}
		
	}

}
