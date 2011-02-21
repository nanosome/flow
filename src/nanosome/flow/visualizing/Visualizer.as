package nanosome.flow.visualizing
{
    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;
    import nanosome.flow.visualizing.ticking.FrameTickGenerator;
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    public class Visualizer
    {
        private var _animator:BaseAnimator;
        private var _AnimatorClass:Class;
        private var _tickGenerator:ITickGenerator;

        private var _mapping:AnimationMapping;

        private var _prevTransition:Transition;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Visualizer(mapping:AnimationMapping, animatorClass:Class)
        {
            _mapping = mapping;
            _AnimatorClass = animatorClass;
            _tickGenerator = new FrameTickGenerator();
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        public function setCustomTickGenerator(tickGenerator:ITickGenerator):void
        {
            _tickGenerator.removeEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _tickGenerator = tickGenerator;
            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
        }

        private function onTickUpdate(event:TickGeneratorEvent):void
        {
            var done:Boolean = !_animator.makeStep(event.delta);
            _animator.update();
            if (done)
            {
                _tickGenerator.stop();
                disposeAnimator();
            }
        }

        private function getAnimator():void
        {
            _animator = new _AnimatorClass();
        }

        private function disposeAnimator():void
        {
            _animator = null;
        }

        public function setTransition(transition:Transition):void
        {
            var isReversing:Boolean = ( _prevTransition &&
                transition.source == _prevTransition.target &&
                transition.target == _prevTransition.source
            );

            getAnimator();
            var easing:TimedEasing = _mapping.getEasingForTransition(transition);

            if (isReversing)
                _animator.reverseTo(easing._easing, easing._duration);
            else
                _animator.switchTo(
                    easing._easing, easing._duration,
                    _mapping.getValueForState(transition.source),
                    _mapping.getValueForState(transition.target)
                );

            _tickGenerator.start(); // kicking it to start it up again

            _prevTransition = transition;
        }

        public function setInitialState(state:State):void
        {
            getAnimator();
            _animator.setInitialValue(_mapping.getValueForState(state));
            disposeAnimator();
        }

    }
}
