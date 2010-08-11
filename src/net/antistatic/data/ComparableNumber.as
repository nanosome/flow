////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.data 
{


public class ComparableNumber implements IComparable 
{
	public var number:Number;
	
	public function ComparableNumber(i:Number) 
	{
		number = i;
	}
	
	public function compareTo(obj:Object):int
	{
		return number - ComparableNumber(obj).number;
	}
	
	public function toString():String
	{
		return String(number);
	}
	
	public function valueOf():Number
	{
		return number;
	}

}
}
