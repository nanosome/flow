package nanosome.flow.visualizing.builders
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.utils.ClassUtils;
    import nanosome.flow.visualizing.ticking.FrameTickGenerator;
    import nanosome.flow.visualizing.ticking.ITickGenerator;

    // VisualMappingBuilder is supposed to be overriden by internal classes to map values of object properties
    // to StateMachine states, and easings of object properties to StateMachine transitions.
    public class VisualMappingBuilder implements IInstanceNameResolver
    {
        protected var __smBuilder:StateMachineBuilder;

        private var __namesMappings:Dictionary;

        private var __visualMappingsStorage:VisualMappingsStorage;

        private var __currentState:State;
        private var __currentTransition:Transition;

        public function VisualMappingBuilder()
        {
            __namesMappings = new Dictionary();

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
            var states:Vector.<State> = __smBuilder.getStateMachine().states;
            var transitions:Vector.<Transition> = __smBuilder.getStateMachine().transitions;

            var i:int;
            var k:uint;
            var instance:Object;
            for (i = 0, k = states.length; i < k; i++)
            {
                for each (instance in __namesMappings)
                {
                    __visualMappingsStorage.storeValuesFor(instance, __namesMappings[instance]);
                }
                __currentState = states[k];
                defineStatesAndTransitions(__currentState, null);
                for each (instance in __namesMappings)
                {
                    __visualMappingsStorage.compareAndMapValuesFor(instance, __namesMappings[instance], __currentState);
                }
            }

            for (i = 0, k = transitions.length; i < k; i++)
            {
                __currentTransition = transitions[k];
                __visualMappingsStorage.setCurrentTransition(__currentTransition);
                defineStatesAndTransitions(null, __currentTransition);
            }
        }

        private function instantiateVariables():void
        {
            var namesAndTypes:Vector.<Array>;
            var nameAndType:Array;
            var name:String;
            var clazz:Class;

            namesAndTypes = ClassUtils.getVariablesNamesAndTypes(this);
            for each (nameAndType in namesAndTypes)
            {
                name = nameAndType[0];
                if (name.substr(0, 2) != "__" && !this[name])
                {
                    clazz = getDefinitionByName(nameAndType[1]) as Class;
                    this[name] = new clazz();
                    __namesMappings[this[name]] = name;
                }
            }
        }

        private function validateMappings():void
        {
            // TODO: Add validation after building is complete
        }

        public function getNameForInstance(instance:Object):String
        {
            return __namesMappings[instance];
        }

        private function identifyStateMachineBuilder():void
        {
            var stateMachineVars:Vector.<String> = ClassUtils.getVariablesOfTypeOrInherited(this, StateMachineBuilder);

            if (stateMachineVars.length > 0)
                throw new Error("Only one StateMachineBuilder per VisualMappingBuilder allowed");

            __smBuilder = this[stateMachineVars[0]];
        }

        //--------------------------------------------------------------------------
        //
        //  This methods returns mapping builder
        //
        //--------------------------------------------------------------------------


        protected function animate(propertyName:String):MappingAnimatorBuilder
        {
            var mapper:MappingAnimatorBuilder = new MappingAnimatorBuilder(this, __visualMappingsStorage);
            mapper.andProperty(propertyName);
            return mapper;
        }

        protected function ease(instance:Object, propertyName:String = ""):MappingEasingBuilder
        {
            var mapper:MappingEasingBuilder = new MappingEasingBuilder(this, __visualMappingsStorage);
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
