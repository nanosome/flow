package nanosome.flow.visualizing.builders
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.stateMachine.builders.StateMachineBuilder;
    import nanosome.flow.utils.ClassUtils;
    import nanosome.flow.visualizing.ticking.FrameTickGenerator;
    import nanosome.flow.visualizing.ticking.ITickGenerator;

    /**
     * VisualMappingBuilder is supposed to be overriden by internal classes to map values of object properties
     * to StateMachine states, and easings of object properties to StateMachine transitions.
     *
     * Public properties of child class will be attempted to auto-instantiate, so use other
     * scope (like protected) to avoid it.
     */
    public class VisualMappingBuilder implements IInstanceNameResolver
    {
        protected var _smBuilder:StateMachineBuilder;

        protected var _namesMappings:Dictionary;
        protected var _mappingsAndAnimatorsStorage:MappingsAndAnimatorsStorage;

        private var _currentState:State;
        private var _currentTransition:Transition;

        public function VisualMappingBuilder()
        {
            _mappingsAndAnimatorsStorage = new MappingsAndAnimatorsStorage();
            _namesMappings = new Dictionary();

            instantiateVariables();
            identifyStateMachineBuilder();
            registerAnimators();
            _defineStatesAndTransitions();
            validateMappings();
        }

        protected function getTickGenerator():ITickGenerator
        {
            return new FrameTickGenerator();
        }

        private function _defineStatesAndTransitions():void
        {
            var states:Vector.<State> = _smBuilder.getStateMachine().states;
            var transitions:Vector.<Transition> = _smBuilder.getStateMachine().transitions;

            var i:int;
            var k:uint;
            var instance:Object;
            for (i = 0, k = states.length; i < k; i++)
            {
                for (instance in _namesMappings)
                {
                    _mappingsAndAnimatorsStorage.storeValuesFor(instance, _namesMappings[instance]);
                }
                _currentState = states[i];
                defineStatesAndTransitions(_currentState, null);
                for (instance in _namesMappings)
                {
                    _mappingsAndAnimatorsStorage.compareAndMapValuesFor(instance, _namesMappings[instance], _currentState);
                }
            }

            for (i = 0, k = transitions.length; i < k; i++)
            {
                _currentTransition = transitions[i];
                defineStatesAndTransitions(null, _currentTransition);
            }
        }

        private function instantiateVariables():void
        {
            var namesAndTypes:Vector.<Array>;
            var name:String;
            var clazz:Class;
            var i:int;
            var k:uint;

            namesAndTypes = ClassUtils.getVariablesNamesAndTypes(this);
            for (i = 0, k = namesAndTypes.length; i < k; i++)
            {
                name = namesAndTypes[i][0];
                if (!this[name])
                {
                    clazz = getDefinitionByName(namesAndTypes[i][1]) as Class;
                    this[name] = new clazz();
                    if (!(this[name] is StateMachineBuilder))
                        _namesMappings[this[name]] = name;
                }
            }
        }

        private function validateMappings():void
        {
            // TODO: Add validation after building is complete
        }

        public function getNameForInstance(instance:Object):String
        {
            return _namesMappings[instance];
        }

        private function identifyStateMachineBuilder():void
        {
            var stateMachineVars:Vector.<String> = ClassUtils.getVariablesOfTypeOrInherited(this, StateMachineBuilder);

            if (stateMachineVars.length > 1)
                throw new Error("Only one StateMachineBuilder per VisualMappingBuilder allowed");
            else if (stateMachineVars.length == 0)
                throw new Error("We need at least one StateMachineBuilder per VisualMappingBuilder");

            _smBuilder = this[stateMachineVars[0]];
        }

        //--------------------------------------------------------------------------
        //
        //  This methods returns mapping builders
        //
        //--------------------------------------------------------------------------


        protected function animate(propertyName:String):MappingAnimatorBuilder
        {
            var mapper:MappingAnimatorBuilder = new MappingAnimatorBuilder(this, _mappingsAndAnimatorsStorage);
            mapper.andProperty(propertyName);
            return mapper;
        }

        protected function ease(instance:Object, propertyName:String = ""):MappingEasingBuilder
        {
            var mapper:MappingEasingBuilder = new MappingEasingBuilder(this, _mappingsAndAnimatorsStorage, _currentTransition);
            mapper.and(instance, propertyName);
            return mapper;
        }

        //--------------------------------------------------------------------------
        //
        //  This methods are supposed to be overriden
        //
        //--------------------------------------------------------------------------

        protected function registerAnimators():void
        {
            throw new Error("This method should be overriden");
        }

        protected function defineStatesAndTransitions(state:State, transition:Transition):void
        {
            throw new Error("This method should be overriden");
        }

    }
}
