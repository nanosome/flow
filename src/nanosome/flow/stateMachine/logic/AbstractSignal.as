package nanosome.flow.stateMachine.logic 
{
	/**
	 * @author dimitri.fedorov
	 */
	public class AbstractSignal  
	{
		private var _id:String; 
		
		public function AbstractSignal(id:String)
		{
			_id = id;
		}
		
		public function get id():String
		{
			return _id;
		}
		
	}
}
