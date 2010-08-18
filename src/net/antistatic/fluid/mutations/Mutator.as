////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.mutations
{
		
	import flash.events.Event;

	import nanosome.flow.stateMachine.StateMachine;
	import nanosome.flow.stateMachine.logic.AbstractStateMachine;
	import net.antistatic.fluid.IStepStateMachine;
	import net.antistatic.fluid.mutations.MutationBehaviour;
	
	/**
	 *  MutatorManager class is a subclass of StateMachine and manages all the mutators it contain.
	 *  
	 *  @see StateMachine
	 *  
	 *  @author ai #212983
	 */
	public class Mutator extends StateMachine implements IStepStateMachine
	{
			
		/**
		 * @private
		 * Holds mutation behaviour will be used. 
		 */
		private var behaviour:MutationBehaviour;	
	
		/**
		 * @private
		 * Holds mutation will be used. 
		 */
		private var mutation:Mutation;
		
		private var mutant:IMutatable;
		
		private var mutationState:MutationBehaviourStateVO;		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 */	
		public function Mutator(logic:AbstractStateMachine, behaviour:MutationBehaviour, mutation:Mutation, mutant:IMutatable)
		{
			super(logic);
			this.behaviour = behaviour;
			this.mutation = mutation;
			this.mutant = mutant;
			addEventListener(StateMachine.HAS_CHANGED, onStateMachineChange);
			if(logic.countStates() != behaviour.countValues())
				throw new Error("Amount of StateMachineLogic states ("+logic.countStates()
								+") and MutationBehaviour values ("+behaviour.countValues()+") should match!");
			if(logic.countEdges() != behaviour.countEasingLines())
				throw new Error("Amount of StateMachineLogic edges ("+logic.countEdges()
								+") and MutationBehaviour EasingLines ("+behaviour.countEasingLines()+") should match!");
		}
		
		private function onStateMachineChange(event:Event):void
		{
			mutationState = behaviour.setValueAndEasingByID(mutationState, logic.getIDForState(getCurrentState()), Number(getCurrentAction()));
			apply(); 
		}
	
		public function initiate(initiatingStateID:uint = 0):void
		{
			setState(logic.getStateForID(initiatingStateID));
			mutationState = behaviour.initWithValueID(initiatingStateID);
			apply();
		}
	
	
		/**
		 *  Performs a step to further mutation.
		 *  
		 *  @return false, if no steps were made
		 */		 
		public function step():Boolean
		{
			var newState:MutationBehaviourStateVO = behaviour.step(mutationState);
			if(newState == null) return false;
			else
			{
				mutationState = newState;
				apply();
				return true;
			}
		}		
				
	
		public function apply():void
		{
			mutant.applyMutation(mutation, mutationState.value);
		}
	
	}

}
