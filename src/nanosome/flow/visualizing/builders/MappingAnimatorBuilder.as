package nanosome.flow.visualizing.builders
{
    public class MappingAnimatorBuilder
    {
        private var _propertyNames:Vector.<String>;
        private var _instanceNames:Vector.<String>;

        private var _animatorRegistrator:IAnimatorRegistrator;
        private var _nameResolver:IInstanceNameResolver;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function MappingAnimatorBuilder(
            nameResolver: IInstanceNameResolver,
            animatorRegistrator:IAnimatorRegistrator
        )
        {
            _propertyNames = new Vector.<String>();
            _instanceNames = new Vector.<String>();
            _animatorRegistrator = animatorRegistrator;
            _nameResolver = nameResolver;
        }

        public function andProperty(propertyName:String):MappingAnimatorBuilder
        {
            _propertyNames.push(propertyName);
            return this;
        }

        public function ofInstance(instance:Object):MappingAnimatorBuilder
        {
            _instanceNames.push(_nameResolver.getNameForInstance(instance));
            return this;
        }

        public function ofInstances(...instances):MappingAnimatorBuilder
        {
            var k:uint;
            var i:int;
            for (i = 0, k = instances.length; i < k; i++)
            {
                 ofInstance(instances[i]);
            }
            return this;
        }

        public function by(animatorClass:Class):void
        {
            var i:int;
            var k:uint;
            var p:int;
            var m:uint;

            for (i = 0, k = _instanceNames.length; i < k; i++)
            {
                for (p = 0, m = _propertyNames.length; p < m; p++)
                {
                    _animatorRegistrator.registerAnimator(_instanceNames[i], _propertyNames[p], animatorClass);
                }
            }
        }
    }
}
