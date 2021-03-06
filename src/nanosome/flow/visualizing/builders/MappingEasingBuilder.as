package nanosome.flow.visualizing.builders
{
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.TimedEasing;

    public class MappingEasingBuilder
    {
        private var _propertyNames:Vector.<String>;
        private var _instanceNames:Vector.<String>;

        private var _transition:Transition;

        private var _easingRegistrator:IEasingRegistrator;
        private var _nameResolver:IInstanceNameResolver;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function MappingEasingBuilder(
            nameResolver: IInstanceNameResolver,
            easingRegistrator:IEasingRegistrator,
            transition:Transition
        )
        {
            _propertyNames = new Vector.<String>();
            _instanceNames = new Vector.<String>();
            _easingRegistrator = easingRegistrator;
            _nameResolver = nameResolver;
            _transition = transition;
        }

        public function and(instance:Object, propertyName:String = ""):MappingEasingBuilder
        {
            _instanceNames.push(_nameResolver.getNameForInstance(instance));
            _propertyNames.push(propertyName);
            return this;
        }

        public function by(easingFunction:Function, duration:uint):void
        {
            var i:int;
            var k:uint;

            for (i = 0, k = _instanceNames.length; i < k; i++)
            {
                _easingRegistrator.registerEasing(
                    _instanceNames[i], _propertyNames[i],
                    _transition, new TimedEasing(easingFunction, duration)
                );
            }
        }
    }
}
