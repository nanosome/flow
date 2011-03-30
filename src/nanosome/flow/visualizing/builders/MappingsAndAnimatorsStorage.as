package nanosome.flow.visualizing.builders
{
    import flash.utils.Dictionary;

    import nanosome.flow.ICloneable;
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;
    import nanosome.flow.visualizing.TimedEasing;

    public class MappingsAndAnimatorsStorage implements IAnimatorRegistrator, IEasingRegistrator
    {
        protected var _mappings:Dictionary;
        protected var _animatorClasses:Dictionary;
        protected var _currentValues:Dictionary;

        private var _instanceProps:Dictionary;

        public function MappingsAndAnimatorsStorage()
        {
            _mappings = new Dictionary();
            _animatorClasses = new Dictionary();
            _instanceProps = new Dictionary();
        }

        public function registerAnimator(instanceName:String, propertyName:String, animatorClass:Class):void
        {
            if (!_instanceProps[instanceName])
                _instanceProps[instanceName] = new Vector.<String>();

            var instance:Vector.<String> = _instanceProps[instanceName];

            if (instance.indexOf(propertyName) < 0)
                instance.push(propertyName);

            var key:String = instanceName + "." + propertyName;
            _animatorClasses[key] = animatorClass;
            _mappings[key] = new AnimationMapping();
        }

        public function registerEasing(instanceName:String, propertyName:String, transition:Transition, timedEasing:TimedEasing):void
        {
            if (propertyName == "")
            {
                var properties:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
                var i:int;
                var k:uint;
                for (i = 0, k = properties.length; i < k; i++)
                {
                    registerEasing(instanceName, properties[i], transition, timedEasing);
                }
                return;
            }
            AnimationMapping(_mappings[instanceName + "." + propertyName]).mapTransition(transition, timedEasing);
        }

        internal function getMapping(instanceName:String, propertyName:String):AnimationMapping
        {
            return _mappings[instanceName + "." + propertyName];
        }

        internal function getAnimatorClass(instanceName:String, propertyName:String):Class
        {
            return _animatorClasses[instanceName + "." + propertyName];
        }

        internal function getAllRegisteredPropertiesFor(instanceName:String):Vector.<String>
        {
            return _instanceProps[instanceName];
        }
        
        internal function storeValuesFor(instance:Object, instanceName:String):void
        {
            _currentValues = new Dictionary();
            var props:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
            if (props)
            {
                var i:int;
                var k:uint;

                for (i = 0, k = props.length; i < k; i++)
                {
                    if (instance[props[i]] is ICloneable)
                        _currentValues[instanceName + "." + props[i]] = ICloneable(instance[props[i]]).clone();
                    else
                        _currentValues[instanceName + "." + props[i]] = instance[props[i]];
                }
            }
        }

        internal function compareAndMapValuesFor(instance:Object, instanceName:String, state:State):void
        {
            var props:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
            if (props)
            {
                var i:int;
                var k:uint;
                var value:*;
                var key:String;

                for (i = 0, k = props.length; i < k; i++)
                {
                    value = instance[props[i]];
                    key = instanceName + "." + props[i];
                    if (value != _currentValues[key] && _mappings[key])
                        AnimationMapping(_mappings[key]).mapValue(state, value);
                }
            }
        }

    }
}
