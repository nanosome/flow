package nanosome.flow.visualizing.builders
{
    public class PropertyAnimatorMappingBuilder
    {
        private var _propertyNames:Vector.<String>;
        private var _instanceNames:Vector.<String>;
        private var _animatorClass:Class;

        private var _nameResolver:IInstanceNameResolver;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function PropertyAnimatorMappingBuilder(instanceNameResolver:IInstanceNameResolver)
        {
            _propertyNames = new Vector.<String>();
            _instanceNames = new Vector.<String>();
            _nameResolver = instanceNameResolver;
        }

        public function andProperty(propertyName:String):PropertyAnimatorMappingBuilder
        {
            _propertyNames.push(propertyName);
            return this;
        }

        public function ofInstance(instance:Object):PropertyAnimatorMappingBuilder
        {
            _instanceNames.push(_nameResolver.getNameForInstance(instance));
            return this;
        }

        public function ofInstances(...instances):PropertyAnimatorMappingBuilder
        {
            var k:uint;
            var i:int;
            for (i = 0, k = instances.length; i < k; i++)
            {
                 ofInstance(instances[i]);
            }
            return this;
        }

        public function useAnimator(animatorClass:Class):void
        {
            _animatorClass = animatorClass;
        }

        internal function checkNameAndReturnAnimatorClass(instanceName:String, property:String):Class
        {
            if (_propertyNames.indexOf(instanceName) < 0)
                return null;

            if (_propertyNames.indexOf(property) < 0)
                return null;

            return _animatorClass;
        }

    }
}
