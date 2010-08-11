////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.logic 
{

/**
 * Simple although powerful class used for building conditions for State Machines.
 * Stores function (which should return Boolean type), its related object and their parameters.
 *  
 * @author ai #212983
 */
public class BooleanCondition
{
	/**
	 * @private
	 * Holds checking function
	 */
	private var func:Function;
	
	/**
	 * @private
	 * Holds object checking function will be applied to
	 */
	private var obj:Object;
	
	/**
	 * @private
	 * Holds array of parameters for checking function
	 */
	private var params:Array;
	
	/**
	 * @private
	 * Holds if the result of the checking function needs negation
	 */
	private var negation:Boolean;

	/**
	 * @private
	 * Holds additional Conditions will be treated as AND
	 */
	private var andConditions:Array; /* of BooleanCondition */

	/**
	 * @private
	 * Holds additional Conditions will be treated as OR
	 */
	private var orConditions:Array; /* of BooleanCondtition */


	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 *  
	 *  @param func Function will be run when checking BooleanCondition
	 *  @param obj Object used for applying checking function 
	 *  @param params Parameters for checking function 
	 *  @param negation Will checking require negation of the function result
	 */		
	public function BooleanCondition(func:Function, obj:Object = null, params:Array = null, negation:Boolean = false)
	{
		this.func = func;
		this.obj = obj;
		this.params = params;
		this.negation = negation;
		andConditions = new Array();
		orConditions = new Array();
	}


	public function and(... rest):BooleanCondition
	{
		var condition:BooleanCondition;
		var res:BooleanCondition = this.yes;
		for each (condition in rest) 
			res.addAndCondition(condition);
		return res;
	}

	public function or(... rest):BooleanCondition
	{
		var condition:BooleanCondition;
		var res:BooleanCondition = this.yes;
		for each (condition in rest) 
			res.addOrCondition(condition);
		return res;
	}
		
	public function addAndCondition(condition:BooleanCondition):void
	{
		andConditions.push(condition);
	}
	
	public function addOrCondition(condition:BooleanCondition):void
	{
		orConditions.push(condition);
	}
	
	private function copyConditionsTo(otherCondition:BooleanCondition):void
	{
		var condition:BooleanCondition;		
		for each (condition in orConditions) 
			otherCondition.addOrCondition(condition);
		for each (condition in andConditions) 
			otherCondition.addAndCondition(condition);			
	}
	/**
	 *  Returns the same BooleanCondition, but in the new object.
	 *  You can make fun stuff like doYouWantSomeBeer = myWifeAtHome.no.yes.no.no.yes.no! 
	 *  
	 *  @return BooleanCondition object (a new one)
	 */		
	public function get yes():BooleanCondition
	{
		var newCondition:BooleanCondition = new BooleanCondition(func, obj, params, negation);
	 	copyConditionsTo(newCondition);
		return newCondition; 
	}

	/**
	 *  Returns negated BooleanCondition, returning opposite result, if checked
	 *  
	 *  @return negated BooleanCondition object
	 */			
	public function get no():BooleanCondition
	{
		var newCondition:BooleanCondition = new BooleanCondition(func, obj, params, !negation);
	 	copyConditionsTo(newCondition);
		return newCondition; 
	}

	/**
	 *  Performs check of the BooleanCondition
	 *
	 *	@param context Context this condition will be checked within. If not null, added to the params.
	 *	
	 *  @return result of the BooleanCondition check
	 */			
	public function check(context:* = null):Boolean
	{
		var condition:BooleanCondition;
		var fparams:Array = null;
		if(params!=null)
			fparams = params.concat(); // copy array
		if(context!=null)
			fparams = (fparams == null) ? [context] : fparams.concat(context);
		var res:Boolean = func.apply(obj, fparams);
		
		for each (condition in orConditions) 
			res = res || condition.check(context);

		for each (condition in andConditions) 
			res = res && condition.check(context);

		if (negation) res = !res; 
		// negation in the end is critical for derivatives, i.e. someCondition.or(orCondition).no
		// please keep an eye on another derivatives and change logic if needed
		return res;
	}
}
}
