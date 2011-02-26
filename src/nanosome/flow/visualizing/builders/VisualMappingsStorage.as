package nanosome.flow.visualizing.builders
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.AnimationMapping;
    import nanosome.flow.visualizing.TimedEasing;

    public class VisualMappingsStorage implements IAnimatorRegistrator, IEasingRegistrator
    {
        private var _mappings:Dictionary;
        private var _animatorClasses:Dictionary;
        private var _currentValues:Dictionary;

        private var _instances:Dictionary;

        private var _currentTransition:Transition;

        public function VisualMappingsStorage()
        {
            _mappings = new Dictionary();
            _animatorClasses = new Dictionary();
            _instances = new Dictionary();
        }

        public function registerAnimator(instanceName:String, propertyName:String, animatorClass:Class):void
        {
            if (!_instances[instanceName])
                _instances[instanceName] = new Vector.<String>();

            var instance:Vector.<String> = _instances[instanceName];

            if (instance.indexOf(propertyName) < 0)
                instance.push(propertyName);

            _animatorClasses[instanceName + "." + propertyName] = animatorClass;
        }

        public function registerEasing(instanceName:String, propertyName:String, timedEasing:TimedEasing):void
        {
            if (propertyName == "")
            {
                var properties:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
                var i:int;
                var k:uint;
                for (i = 0, k = properties.length; i < k; i++)
                {
                    registerEasing(instanceName, properties[i], timedEasing);
                }
                return;
            }
            getMapping(instanceName, propertyName).mapTransition(_currentTransition, timedEasing);
        }

        internal function getMapping(instanceName:String, propertyName:String):AnimationMapping
        {
             var key:String = instanceName + "." + propertyName;
            if (!_mappings[key])
                _mappings[key] = new AnimationMapping();
            return _mappings[key];
        }

        private function getAllRegisteredPropertiesFor(instanceName:String):Vector.<String>
        {
            return _instances[instanceName];
        }

        internal function setCurrentTransition(transition:Transition):void
        {
            _currentTransition = transition;
        }

        internal function storeValuesFor(instance:Object, instanceName:String):void
        {
            _currentValues = new Dictionary();
            var props:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
            var i:int;
            var k:uint;
            for (i = 0, k < props.length; i < k; i++)
            {
                _currentValues[instanceName + "." + props[i]] = instance[props[i]];
            }
        }

        internal function compareAndMapValuesFor(instance:Object, instanceName:String, state:State):void
        {
            var props:Vector.<String> = getAllRegisteredPropertiesFor(instanceName);
            var i:int;
            var k:uint;
            var value:*;
            for (i = 0, k < props.length; i < k; i++)
            {
                value = instance[props[i]];
                if (value != _currentValues[instanceName + "." + props[i]])
                {
                    getMapping(instanceName,  props[i]).mapValue(state, value);
                }
            }
        }

    }
}
