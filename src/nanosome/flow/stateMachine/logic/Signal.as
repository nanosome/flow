package nanosome.flow.stateMachine.logic 
{
	/**
	 * @author dimitri.fedorov
	 */
	public class Signal  
	{
		private var _id:String; 
		
		public function Signal(id:String)
		{
			_id = id;
		}
		
		public function get id():String
		{
			return _id;
		}
		
	}
}
