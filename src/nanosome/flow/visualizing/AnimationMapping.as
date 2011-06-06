package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;

    public class AnimationMapping
    {
        internal var _values:Dictionary;
        internal var _easings:Dictionary;

        private var _useExternalValues:Boolean = false;
        private var _useExternalEasings:Boolean = false;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function AnimationMapping()
        {
            _values = new Dictionary();
            _easings = new Dictionary();
        }

        public function mapValue(state:State, value:*):void
        {
            if (_useExternalValues)
                throw new Error("External values mapping is used, you can't map it in this class.");

            _values[state] = value;
        }

        public function mapEasing(transition:Transition, timedEasing:TimedEasing):void
        {
            if (_useExternalValues)
                throw new Error("External values mapping is used, you can't map it in this class.");

            _easings[transition] = timedEasing;
        }

        public function getEasingForTransition(transition:Transition):TimedEasing
        {
            return _easings[transition];
        }

        public function getValueForState(state:State):*
        {
            return _values[state];
        }

        //--------------------------------------------------------------------------
        //
        //  Because of AnimationMappings quite often are sharing values or easings
        //  mappings, we're implementing ability to use external Dictionaries for mapping.
        //
        //--------------------------------------------------------------------------


        public function useValuesMapping(valuesMapping:Dictionary):void
        {
            _useExternalValues = true;
            _values = valuesMapping;
        }

        public function useEasingsMapping(easingsMapping:Dictionary):void
        {
            _useExternalEasings = true;
            _easings = easingsMapping;
        }

    }
}
