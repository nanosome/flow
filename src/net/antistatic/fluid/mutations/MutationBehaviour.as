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
public class MutationBehaviour
{
	/**
	 * @private
	 * Holds array with values. 
	 */
	private var values:Array;	/* of Number */
	
	/**
	 * @private
	 * Holds array easingLines. 
	 */
	private var easingLines:Array; /* of easingLine */	
		
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 *  
	 *  @param objects Array of the objects mutations will be applied to
	 *  @param mutation Mutation to be used to change objects properties.
	 *  @param initialState Initial state of the Mutator
	 */	
	public function MutationBehaviour()
	{
		this.values = new Array();
		this.easingLines = new Array();		
	}
	
	public function countValues():uint
	{
		return values.length;
	}

	public function countEasingLines():uint
	{
		return easingLines.length;
	}
		
	/**
	 *  Performs a step to further mutation.
	 *  
	 *  @return false, if no steps available
	 */		 
	public function step(state:MutationBehaviourStateVO):MutationBehaviourStateVO
	{
		if(state.easingLine == null) return null; // nothing to do
		if(state.pos>state.easingLine.getDuration()) return null; // still nothing to do...
		else 
		{
			return new MutationBehaviourStateVO(state.pos+1, state.easingLine, 
												state.easingLine.getValue(state.pos, state.from, state.to),
												state.from, state.to);
		}				
	}

	/**
	 *  Calculates position at in the current <code>sourceLine</code> required to seamlessly to <code>targetLine</code>.
	 *  
	 *  @param targetLine New line to be switched to.
	 *  @param targetFrom Source value for the targetLine
	 *  @param targetTo Target value for the targetLine
	 *  @param sourceLine Old line to switch from
	 *  @param sourceValue Curren value of the Mutator, we're about to keep new one as close to it as we can.
	 *  
	 *  @return Position of the playhead in the current easingLine 
	 */			
	protected function getSwitchPositionForLine(targetLine:EasingLine, targetFrom:Number, targetTo:Number, sourceValue:Number):Number
	{
		// value required to catch
		var rVal:Number; 
		
		// actual value during seeking
		var aVal:Number; 
		
		// current position during seeking
		var cPos:Number; 
		
		// 'from' position during seeking
		var fPos:Number; 
		
		// 'to' position during seeking
		var tPos:Number; 
		
		// direction of the new transition
		var dir:Number = targetFrom < targetTo ? 1 : -1;
		
		rVal = sourceValue;
		fPos = 0;
		tPos = targetLine.getDuration();
		
		while (Math.abs(fPos-tPos)>1)
		{
			cPos = Math.round((fPos+tPos)/2);
			aVal = targetLine.getValue(cPos, targetFrom, targetTo);
			if(dir>0)
			{				
				if(aVal>=rVal) tPos = cPos;
				else if(aVal<rVal) fPos = cPos;
			} else 
			{
				if(aVal<=rVal) tPos = cPos;
				else if(aVal>rVal) fPos = cPos;
			}
		}
		return cPos;
	}


	/**
	 *  Setting value implicitly 
	 *  
	 *  @param buttonBehaviour Behaviour listen to.
	 */			
	public function initWithValueID(valueID:uint):MutationBehaviourStateVO
	{
		if(values[valueID] != undefined)		
		{
			return new MutationBehaviourStateVO(0, null, values[valueID], values[valueID], values[valueID]); 
		}	
		return null;
	}

	/**
	 *  Perform state change
	 *  
	 *  @param event
	 */			
	public function setValueAndEasingByID(state:MutationBehaviourStateVO, valueID:uint, easingID:uint):MutationBehaviourStateVO
	{
		if(easingLines[easingID]!=undefined && values[valueID]!=undefined)
		{
			var fromValue:Number = isNaN(state.to) ? values[valueID] : state.to;					
			var toValue:Number = values[valueID];
			var easingLine:EasingLine = easingLines[easingID];
			var value:Number = state.value;
			
			if(value < Math.min(fromValue, toValue)) 
				value = Math.min(fromValue, toValue);

			if(value > Math.max(fromValue, toValue)) 
				value = Math.max(fromValue, toValue);	
			
			return new MutationBehaviourStateVO(getSwitchPositionForLine(easingLine, fromValue, toValue, value),
												easingLine, value, fromValue, toValue);
		}
		else
			throw new Error("Bad IDs '"+valueID+"' ("+values[valueID]+") and '"+easingID+"' ("+easingLines[easingID]+") in MutationBehaviour call");
	}


	//--------------------------------------------------------------------------
	//
	//  Binding stuff
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Adds values.
	 *    
	 *  @param List of (Value) instances.
	 */		
	public function addValues(...rest:Array):void
	{
		for(var i:Number = 0; i < rest.length; i++)
		{
			addValue(rest[i] as Number);
		}
	}

	/**
	 *  Adds value.
	 *    
	 *  @param value: Value.
	 */		
	public function addValue(value:Number):void
	{
		values.push(value);
	}
		
	/**
	 *  Adds easing lines.
	 *    
	 *  @param List of (EasingLine) instances.
	 */		
	public function addEasingLines(...rest:Array):void
	{
		for(var i:Number = 0; i < rest.length; i++)
		{
			addEasingLine((rest[i] as EasingLine));
		}
	}
			
	/**
	 *  Adds easing line.
	 *    
	 *  @param easingLine: EasingLine to add.
	 */		
	public function addEasingLine(easingLine:EasingLine):void
	{
		easingLines.push(easingLine);
	}
			
}

}
