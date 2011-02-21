package nanosome.flow.visualizing
{
    import flash.utils.Dictionary;

    import nanosome.flow.stateMachine.State;
    import nanosome.flow.stateMachine.Transition;
    import nanosome.flow.visualizing.animators.base.BaseAnimator;
    import nanosome.flow.visualizing.ticking.FrameTickGenerator;
    import nanosome.flow.visualizing.ticking.ITickGenerator;
    import nanosome.flow.visualizing.ticking.TickGeneratorEvent;

    import net.antistatic.logging.ILogger;
    import net.antistatic.logging.LogFactory;

    public class Visualizer
    {
        private var _animator:BaseAnimator;
        private var _tickGenerator:ITickGenerator;
        private var _hasTickListener:Boolean;

        private var _mapping:AnimationMapping;

        private var _prevTransition:Transition;
        
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        private var _logger:ILogger;

        public function Visualizer(mapping:AnimationMapping)
        {
            _mapping = mapping;
            _tickGenerator = new FrameTickGenerator();
            _hasTickListener = false;
            _logger = LogFactory.getLogger(this);
        }

        public function setCustomTickGenerator(tickGenerator:ITickGenerator):void
        {

            if (_hasTickListener)
                _tickGenerator.removeEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _tickGenerator = tickGenerator;
        }

        private function onTickUpdate(event:TickGeneratorEvent):void
        {
            if (!_animator.makeStep(event.delta))
                _tickGenerator.stop();
            _animator.update();
        }

        public function setAnimator(animator:BaseAnimator):void
        {
            _animator = animator;
            if (_hasTickListener)
                return;

            _tickGenerator.addEventListener(TickGeneratorEvent.TICK_UPDATE, onTickUpdate);
            _hasTickListener = true;
        }

        public function setTransition(transition:Transition):void
        {

            var isReversing:Boolean = ( _prevTransition &&
                transition.source == _prevTransition.target &&
                transition.target == _prevTransition.source
            );

            var easing:TimedEasing = _mapping.getEasingForTransition(transition);

            if (isReversing)
                _animator.reverseTo(easing._easing, easing._duration);
            else
                _animator.switchTo(easing._easing, easing._duration,
                    _mapping.getValueForState(transition.source), _mapping.getValueForState(transition.target));

            _tickGenerator.start(); // kicking it to start it up again

            _prevTransition = transition;
        }

        public function setInitialState(state:State):void
        {
            _animator.setInitialValue(_mapping.getValueForState(state));
        }

    }
}
