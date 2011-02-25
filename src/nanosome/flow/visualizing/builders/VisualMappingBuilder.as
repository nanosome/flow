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

        private var _namesMappings:Dictionary;
        private var _easingMappings:Vector.<EasingMappingBuilder>;
        private var _animatorMappings:Vector.<PropertyAnimatorMappingBuilder>;

        private var _currentState:State;
        private var _currentTransition:Transition;

        //XXX: I guess we have to instantiate Animators or Visualizers (or both?) here and map em to names too for later use.

        public function VisualMappingBuilder()
        {
            _namesMappings = new Dictionary();
            _animatorMappings = new Vector.<PropertyAnimatorMappingBuilder>();
            _easingMappings = new Vector.<EasingMappingBuilder>();
            instantiateVariables();
            identifyStateMachineBuilder();
            registerAnimators();
            _defineStatesAndTransitions();
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
            for (i = 0, k = states.length; i < k; i++)
            {
                _currentState = states[k];
                defineStatesAndTransitions(_currentState, null);
            }

            for (i = 0, k = transitions.length; i < k; i++)
            {
                _currentTransition = transitions[k];
                defineStatesAndTransitions(null, _currentTransition);
            }
        }

        private function instantiateVariables():void
        {
            var namesAndTypes:Vector.<Array>;
            var nameAndType:Array;
            var clazz:Class;

            namesAndTypes = ClassUtils.getVariablesNamesAndTypes(this);
            for each (nameAndType in namesAndTypes)
            {
                clazz = getDefinitionByName(nameAndType[1]) as Class;
                this[nameAndType[0]] = new clazz();
                _namesMappings[this[nameAndType[0]]] = nameAndType[0];
            }
        }

        public function getNameForInstance(instance:Object):String
        {
            return _namesMappings[instance];
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
        //  This methods returns corresponding builders
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  Builder for mapping animators
        //  to properties and instances
        //----------------------------------

        protected function forProperty(propertyName:String):PropertyAnimatorMappingBuilder
        {
            var propertyAnimatorMapper:PropertyAnimatorMappingBuilder =
                    new PropertyAnimatorMappingBuilder(this);
            _animatorMappings.push(propertyAnimatorMapper);
            propertyAnimatorMapper.andProperty(propertyName);
            return propertyAnimatorMapper;
        }

        //----------------------------------
        //  Builder for mapping easings
        //----------------------------------

        protected function ease(...instances):EasingMappingBuilder
        {
            var easingMappingBuilder:EasingMappingBuilder = new EasingMappingBuilder();
            var i:int;
            var k:uint;
            for (i = 0, k = instances.length; i < k; i++)
            {
                easingMappingBuilder.addInstance(instances[i]);
            }
            
            _easingMappings.push(easingMappingBuilder);
            
            return easingMappingBuilder;
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
