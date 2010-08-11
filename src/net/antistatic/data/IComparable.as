////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.data 
{

public interface IComparable 
{
	/**
	 * Compare two Objects with respect to ordering. Typical
	 * implementations first cast their arguments to particular
	 * types in order to perform comparison.
	 * @param obj object to be compared with this
	 * @return a negative number if this is less than obj; a
	 * positive number if this is greater than obj; else 0
	**/
	function compareTo(obj:Object):int;
}
	
}
