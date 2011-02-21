package nanosome.flow.visualizing.builders
{
    public class ClassAndPropertyAnimatorMapping
    {
        private var _objectClass:Class;
        private var _propertyName:String;
        private var _animatorClass:Class;
        
        public function ClassAndPropertyAnimatorMapping(objectClass:Class, propertyName:String)
        {
            _objectClass = objectClass;
            _propertyName = propertyName;
        }

        public function mapAnimator(animatorClass:Class):void
        {
            _animatorClass = animatorClass;
        }
    }
}
