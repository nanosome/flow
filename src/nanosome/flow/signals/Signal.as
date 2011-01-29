package nanosome.flow.signals
{
    import flash.events.Event;

    /**
     * @author dimitri.fedorov
     */
    public class Signal
    {
        private var _id:String;
        private var _ownerSet:AbstractSignalSet;
        
        public function Signal(id:String, ownerSet:AbstractSignalSet)
        {
            _id = id;
            _ownerSet = ownerSet;
        }
        
        public function get id():String
        {
            return _id;
        }

        public function fire(event:Event = null):void
        {
            _ownerSet.fireSignal(this);
        }
    }
}
