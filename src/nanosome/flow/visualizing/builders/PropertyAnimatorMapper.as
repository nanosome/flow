package nanosome.flow.visualizing.builders
{
    public class PropertyAnimatorMapper
    {
        private var _affectedInstances:Array;
        private var _propertyName:String;
        private var _animatorClass:Class;
        
        public function PropertyAnimatorMapper(propertyName:String)
        {
            _propertyName = propertyName;
            _affectedInstances = [];
        }

        public function ofInstance(instance:*):PropertyAnimatorMapper
        {
            _affectedInstances.push(instance);
            return this;
        }

        public function useAnimator(animatorClass:Class):void
        {
            _animatorClass = animatorClass;
            // notify parental class?
        }

        internal function checkAndReturnAnimatorClass():Class

    }
}
