package net.antistatic.fluid.mutations 
{
import flash.display.DisplayObject;
import net.antistatic.fluid.mutations.IMutatable;

/**
 * @author User
 */
public class SingleMutant implements IMutatable 
{
	protected var object:DisplayObject;
	
	public function SingleMutant(object:DisplayObject)
	{
		this.object = object;
	}
	
	public function applyMutation(mutation:Mutation, value:Number):void
	{
		mutation.applyValue(object, value);
	}
}
}
