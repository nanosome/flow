// @license@
package nanosome.flow.builders 
{
	import nanosome.flow.stateMachine.logic.State;
	import nanosome.flow.stateMachine.logic.Signal;
	
	/**
	 * @author dimitri.fedorov
	 */
	public class SampleStateMachine extends StateMachineBuilder 
	{
		// states
		public var overed:State; 
		public var pressed:State;
		public var pressedOutside:State;
		
		// signals
		public var mouseUp:Signal;
		public var mouseDown:Signal;
		public var mouseOver:Signal;
		public var mouseOut:Signal;
/*	
		var e:Event;
		send(e, 12);
		trace(e);
		
		private function(e:Event, value:uint):void
		{
			e = new Event(value);
		}
		 
*/		
		public function createStateMachine():StateMachine
		{
			from(initial).by(mouseOver).to(overed).back(mouseOut);
			from(mouseOver).by(mouseDown).to(pressed).back(mouseUp);
			from(pressed).by(mouseOut).to(pressedOutside).back(mouseOver);
			from(pressedOutside).by(mouseUp).to(initial);
			
			return getContent();		
		}
	}
}
