package net.antistatic.fluid 
{
	
	/**
	 * @author User
	 */
	public interface IStepStateMachine 
	{
		function checkForStateChange():Boolean;
		function step():Boolean;
		function initiate(initiatingStateID:uint = 0):void;
	}
}
