////////////////////////////////////////////////////////////////////////////////
//
//  FLUID LIBRARY | http://antistatic.net/fluid/
//  Copyright 2008 Antistatic | ai #212983
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

package net.antistatic.fluid.stateMachine.logic 
{
		
	import net.antistatic.fluid.stateMachine.State;
	import net.antistatic.fluid.logic.BooleanCondition;
	
	/**
	 *  StateMachineLogic differs from StateMachine, 
	 *  because it contains logic only, not the current state itself.
	 *  
	 *  It is useful for having many objects with same logic, 
	 *  but different actual states, like buttons.
	 *  
	 *  For example, w/o StateMachineLogic:
	 *  
	 *  var playPauseSM:StateMachine = new StateMachine();
	 *  // ... declaration goes here ...
	 *  var playPauseButton = new Button(playPauseSM);
	 *  
	 *  var muteOnOffM:StateMachine = new StateMachine();
	 *  // ... declaration goes here ...
	 *  var muteOnOffButton = new Button(muteOnOffM); 
	 *
	 * Here we need to describe logic (connections, conditions and dependencies)
	 * twice, because it's two different state machines. With StateMachineLogic things
	 * are much simpler:
	 *  
	 *  var doubleSMLogic:StateMachineLogic = new StateMachineLogic();
	 *  // ... declaration goes here ...
	 *  var playPauseButton = new Button(new StateMachine(doubleSMLogic));
	 *  var muteOnOffButton = new Button(new StateMachine(doubleSMLogic));
	 *   
	 *  playPauseButton.getStateMachine and muteOnOffButton.getStateMachine will
	 *  return two different state machines.
	 *   
	 *  @see StateMachine
	 *  
	 *  @author ai #212983
	 */
	public class StateMachineLogic
	{
	
		/**
		 * @private 
		 * Holds an array for state hubs.
		 */
		private var stateHubs:Array; /* of StateHub */
	
		private var requiredContext:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @param value Value of this state.
		 */	
		public function StateMachineLogic(requiredContext:Class)
		{
			stateHubs = new Array();
			setRequiredContext(requiredContext);
		}
	
		public function setRequiredContext(context:Class):void
		{
			requiredContext = context;
		}
		
		public function countStates():uint
		{
			return stateHubs.length;
		}
	
		public function countEdges():uint
		{
			var stateHub:StateHub;
			var count:uint = 0;
			for each (stateHub in stateHubs)
				count += stateHub.countEdges();
			return count;
		}
		
		public function getRequiredContext():Class
		{
			return requiredContext;
		}
		
		/**
		 *  Adds new State to the behaviour and returns number of states.
		 *  
		 *  @param state State to be added.
		 *  
		 *  @return number of the states in this behaviour
		 */	
		public function addState(state:State):uint
		{
			if(hasHubForState(state))
			{
				throw new Error("This behaviour already has State "+state);
			}
			else 
			{
				stateHubs.push(new StateHub(state));
			}
			return stateHubs.length-1;
		}
		
		/**
		 *  Adds multiple States to the behaviour and returns new number of states.
		 *  Use with caution.
		 *  
		 *  @param list of States to be added.
		 *  
		 *  @return number of the states in this behaviour
		 */	
		public function addStates(...states):uint
		{
			for each(var state:State in states)
				addState(state);
	
			return stateHubs.length-1;
		}	
	
		/**
		 *  Adds ConditionalTransition for the State.
		 *  
		 *  @param fromState State we're adding transition for.
		 *  @param conditionalTransition ConditionalTransition object to be added.
		 *  
		 *  @see ConditionalTransition
		 */		
		public function addConditionalTransition(fromState:State, conditionalTransition:ConditionalTransition):void
		{
			if(hasHubForState(fromState) && hasHubForState(conditionalTransition.getState()))
			{
				getHubForState(fromState).addConditionalTransition(conditionalTransition);
			}
			else 
				throw new Error("StateMachineLogic should contain States '"+fromState+"' and '"+conditionalTransition.getState()+"' both to add transition!");
		}
		
		/**
		 *  Short version of addConditionalTransition.
		 *  
		 *  @param fromState State we're adding transition for.
		 *  @param conditionalTransition ConditionalTransition object to be added.
		 *  
		 *  @see ConditionalTransition
		 */		
		public function addTransition(fromState:State, condition:BooleanCondition, toState:State, action:uint):void
		{
			addConditionalTransition(fromState, new ConditionalTransition(condition, toState, action));
		}
		
		/**
		 *  Performs check for the new transition, returns new transition, if its conditions are met.
		 *  
		 *  @param state State you want to check.
		 *  @param context Context you want to check within.
		 *  @return Transition object.
		 */		
		public function checkForStateTransition(state:State, context:* = null):Transition
		{
			if(!(context is requiredContext))
			{
				throw new Error("This StateMachineLogic requires '"+requiredContext+"' context.");
			}
			var stateHub:StateHub = getHubForState(state);
			if(stateHub != null)
			{
				return stateHub.checkForTransition(context);
			}
			else
				throw new Error("StateMachineLogic should contain State '"+state+"'!");
		}
		
		/**
		 *  Performs check for the new transition with State object, returns new transition, if contains given State.
		 *  
		 *  @return Transition object.
		 */             
		public function checkWithState(stateToCheck:State, supposedState:State):Transition
		{
			var stateHub:StateHub = getHubForState(stateToCheck);
			if(stateHub != null)
			{
				return stateHub.checkWithState(supposedState);
			}
			else
				throw new Error("StateMachineLogic should contain State '"+stateToCheck+"'!");		
		}
		
	
		/**
		 *  Stringifier for the State class
		 *  
		 *  @return String used for output.
		 */		
		public function toString():String
		{
			return "[object StateMachineLogic: "+stateHubs.length+" state hubs ";
		}
	
	
		public function hasHubForState(state:State):Boolean
		{
			return getHubForState(state) != null;
		}
		
		public function getHubForState(state:State):StateHub
		{
			var stateHub:StateHub;
			for each(stateHub in stateHubs)
				if (stateHub.getState() == state) return stateHub;
			return null;
		}
		
		public function getIDForState(state:State):uint
		{
			var i:uint;
			for(i=0; i<stateHubs.length; i++)
				if ((stateHubs[i] as StateHub).getState() == state) return i;
			return null;
		}	
	
		public function getStateForID(id:uint):State
		{
			return stateHubs[id] != null ? (stateHubs[id] as StateHub).getState() : null;
		}	
	}

}

