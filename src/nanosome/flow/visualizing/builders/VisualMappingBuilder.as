package nanosome.flow.visualizing.builders
{
    import flash.utils.getDefinitionByName;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.stateMachine.builder.StateMachineBuilder;
    import nanosome.flow.utils.ClassUtils;
    import nanosome.flow.visualizing.ticking.FrameTickGenerator;
    import nanosome.flow.visualizing.ticking.ITickGenerator;

    // VisualMappingBuilder is supposed to be overriden by internal classes to map values of object properties
    // to StateMachine states, and easings of object properties to StateMachine transitions.
    public class VisualMappingBuilder
    {
        protected var __smBuilder:StateMachineBuilder;

        private var _animatorMappings:Vector.<PropertyAnimatorMapper>;

        public function VisualMappingBuilder()
        {
            _animatorMappings = new Vector.<PropertyAnimatorMapper>();
            instantiateVariables();
            identifyStateMachineBuilder();
            registerAnimators();
            _defineStatesAndTransitions();
        }

        protected function getTickGenerator():ITickGenerator
        {
            return new FrameTickGenerator();
        }

        protected function forProperty(propertyName:String):PropertyAnimatorMapper
        {
            var propertyAnimatorMapper:PropertyAnimatorMapper = new PropertyAnimatorMapper(propertyName);
            _animatorMappings.push(propertyAnimatorMapper);
            return propertyAnimatorMapper;
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
            }
        }

        private function identifyStateMachineBuilder():void
        {
            var stateMachineVars:Vector.<String> = ClassUtils.getVariablesOfTypeOrInherited(this, StateMachineBuilder);

            if (stateMachineVars.length > 0)
                throw new Error("Only one StateMachineBuilder per VisualMappingBuilder allowed");

            __smBuilder = this[stateMachineVars[0]];
        }



        protected function registerAnimators():void
        {

        }

        protected function defineStatesAndTransitions(state:State, transition:Transition):void
        {

        }

    }
}
